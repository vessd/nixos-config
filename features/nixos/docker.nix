{
  lib,
  pkgs,
  config,
  ...
}:
let
  user = lib.attrByPath [ "preferences" "user" "name" ] null config;
in
{
  virtualisation.docker = {
    enable = true;
    extraPackages = [
      pkgs.docker-compose
      pkgs.docker-buildx
    ];
  };

  users.extraGroups.docker.members = lib.optional (user != null) user;
}
