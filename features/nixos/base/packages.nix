{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.ncdu
        pkgs.ripgrep
        pkgs.fd
        pkgs.dig
      ];
    };
}
