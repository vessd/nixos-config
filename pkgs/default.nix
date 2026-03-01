final: prev: {
  assistant = prev.callPackage ./assistant/package.nix { };
  pritunl-openvpn-auth = prev.callPackage ./pritunl-openvpn-auth/package.nix { };
}
