{
  flake.nixosModules.base =
    { lib, pkgs, ... }:
    {
      # https://github.com/NixOS/nixpkgs/issues/433324
      services.speechd.enable = lib.mkForce false;

      environment.systemPackages = [
        pkgs.ncdu
        pkgs.ripgrep
        pkgs.fd
        pkgs.dig
      ];
    };
}
