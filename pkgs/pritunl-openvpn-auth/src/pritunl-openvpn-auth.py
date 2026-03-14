import base64
import binascii
import hashlib
import json
import math
import os
import sys
import time
from pathlib import Path

import pyotp
from nacl.encoding import RawEncoder
from nacl.public import Box, PrivateKey, PublicKey


def extract_totp(otp_path: Path) -> str:
    uri = otp_path.read_text().strip()
    try:
        otp = pyotp.parse_uri(uri)
        if isinstance(otp, pyotp.TOTP):
            code = otp.now()
        else:
            print("Invalid otpauth type", file=sys.stderr)
            sys.exit(3)
    except Exception as e:
        print(f"Invalid otpauth URI: {e}", file=sys.stderr)
        sys.exit(3)
    return code


def extract_server_box_public_key(ovpn_path: Path) -> str:
    inside = False
    json_lines = []

    for line in ovpn_path.read_text().splitlines():
        stripped = line.strip()

        if stripped.startswith("#{"):
            inside = True

        if inside:
            if stripped.startswith("#"):
                stripped = stripped[1:].lstrip()
            json_lines.append(stripped)

        if stripped.startswith("}"):
            break

    if not json_lines:
        raise ValueError("Embedded JSON block not found")

    json_text = "\n".join(json_lines)
    data = json.loads(json_text)

    key = data.get("server_box_public_key")
    if not key:
        raise ValueError("server_box_public_key not found")

    return key


def rand_str_complex(n: int) -> str:
    for _ in range(10):
        byte_len = math.ceil(n * 1.4)
        random_bytes = os.urandom(byte_len)

        encoded = base64.a85encode(
            random_bytes,
        ).decode()

        if len(encoded) >= n:
            return encoded[:n]

    raise RuntimeError("Random complex generate error")


def encrypt_box(server_box_public_key, password, auth_token) -> tuple[str, str]:
    """
    https://github.com/pritunl/pritunl-client-electron/blob/1.3.4466.51/service/connection/ovpn.go#L583
    """

    timestamp = str(int(time.time()))
    auth_data = auth_token + timestamp + password
    auth_bytes = auth_data.encode()

    # 3. Ephemeral key
    ephemeral_priv = PrivateKey.generate()
    ephemeral_pub = ephemeral_priv.public_key

    # 4. Nonce
    pub_hash = hashlib.sha256(bytes(ephemeral_pub)).digest()
    nonce = pub_hash[:24]

    # 5. Box
    server_pub = PublicKey(base64.b64decode(server_box_public_key), encoder=RawEncoder)

    box = Box(ephemeral_priv, server_pub)
    encrypted = box.encrypt(auth_bytes, nonce).ciphertext

    # 6. Username и password
    username = base64.b64encode(bytes(ephemeral_pub)).decode().rstrip("=")
    cipher64 = base64.b64encode(encrypted).decode().rstrip("=")

    password = "$x$" + cipher64

    return username, password


def test_encrypt():
    server_box_private_key = "n9ZmfZ6+XIIc0vRRyJPiypVtM8yzmlPbrCeDk7gwVqY="
    server_box_public_key = "c5H2HYz9H14w3Cb/FYyaYaoYGFT2ibAJrg5po/3PJQE="
    totp = "267314"
    auth_token = "lcY;MLc3aMeV7OME"

    username, password = encrypt_box(server_box_public_key, totp, auth_token)
    auth_password, decrypt_auth_token, auth_nonce, auth_timestamp = decrypt_box(
        server_box_private_key, username, password[3:]
    )

    assert totp == auth_password
    assert auth_token == decrypt_auth_token


def decrypt_box(auth_box_private_key, sender_pub_key64, cipher_data64):
    """
    https://github.com/pritunl/pritunl/blob/1.32.4537.56/pritunl/clients/clients.py#L1257
    """

    if len(sender_pub_key64) > 128:
        raise ValueError("Sender pub key too long")

    if len(cipher_data64) > 256:
        raise ValueError("Sender cipher data too long")

    sender_pub_key64 += "=" * (-len(sender_pub_key64) % 4)
    cipher_data64 += "=" * (-len(cipher_data64) % 4)

    sender_pub_key = PublicKey(base64.b64decode(sender_pub_key64))

    pub_key_hash = hashlib.sha256(bytes(sender_pub_key)).digest()
    nonce = pub_key_hash[:24]
    auth_nonce = binascii.hexlify(pub_key_hash)

    priv_key = PrivateKey(base64.b64decode(auth_box_private_key))

    cipher_data = base64.b64decode(cipher_data64)

    nacl_box = Box(priv_key, sender_pub_key)

    plaintext = nacl_box.decrypt(cipher_data, nonce).decode()

    auth_token = plaintext[:16]
    auth_password = plaintext[26:]
    auth_timestamp = int(plaintext[16:26])

    return auth_password, auth_token, auth_nonce, auth_timestamp


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <ovpn-file> <otp-file>", file=sys.stderr)
        sys.exit(1)

    server_box_public_key = extract_server_box_public_key(Path(sys.argv[1]))
    totp = extract_totp(Path(sys.argv[2]))
    auth_token = rand_str_complex(16)

    username, password = encrypt_box(server_box_public_key, totp, auth_token)

    print(username)
    print(password)


if __name__ == "__main__":
    main()
