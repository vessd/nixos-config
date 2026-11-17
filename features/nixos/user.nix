{ lib, config, ... }:
let
  cfg = config.preferences.user;
in
{
  options.preferences.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "sergey";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Сергей";
    };
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = cfg.fullName;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
