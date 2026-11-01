{
  lib,
  pkgs,
  config,
  ...
}:
let
  user = config.preferences.user.name or null;
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
