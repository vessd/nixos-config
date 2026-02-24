{ quadlet-nix, ... }:
{
  imports = [
    quadlet-nix.homeManagerModules.quadlet
    ./pgadmin.nix
    ./yandex-disk.nix
  ];
}
