{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.pciutils
    pkgs.ncdu
    pkgs.ripgrep
    pkgs.fd
    pkgs.dig
  ];

  services.openssh.enable = true;
  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/433324
  services.speechd.enable = lib.mkForce false;
}
