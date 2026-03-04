{ quadlet-nix, ... }:
{
  imports = [
    quadlet-nix.homeManagerModules.quadlet
    ./pgadmin.nix
    ./xray.nix
    ./yandex-disk.nix
  ];
}
