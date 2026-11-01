{
  flake.nixosModules.user =
    { lib, config, ... }:
    let
      cfg = config.preferences.user;
    in
    {
      options.preferences.user = {
        name = lib.mkOption {
          type = lib.types.str;
        };

        fullName = lib.mkOption {
          type = lib.types.str;
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
    };
}
