{ pkgs, ... }:
{
  assistant = pkgs.callPackage ./assistant/package.nix { };
  pritunl-openvpn-auth = pkgs.callPackage ./pritunl-openvpn-auth/package.nix { };
}
