{
  writers,
  python3Packages,
}:

writers.writePython3Bin "pritunl-openvpn-auth" {
  libraries = with python3Packages; [
    pynacl
    pyotp
  ];
  doCheck = false;
} (builtins.readFile ./src/pritunl-openvpn-auth.py)
