{ pkgs, ... }:
{
  assistant = pkgs.callPackage ./assistant/package.nix { };
  is-weekday = pkgs.callPackage ./is-weekday/package.nix { };
  pritunl-openvpn-auth = pkgs.callPackage ./pritunl-openvpn-auth/package.nix { };
}
