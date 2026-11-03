{ lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/issues/433324
  services.speechd.enable = lib.mkForce false;

  environment.systemPackages = [
    pkgs.pciutils
    pkgs.ncdu
    pkgs.ripgrep
    pkgs.fd
    pkgs.dig
  ];
}
