{ pkgs, ... }:
{
  is-weekday = pkgs.callPackage ./is-weekday/package.nix { };
  jellyfin-link = pkgs.callPackage ./jellyfin-link/package.nix { };
  pritunl-openvpn-auth = pkgs.callPackage ./pritunl-openvpn-auth/package.nix { };
}
