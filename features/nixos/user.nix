{
  flake.nixosModules.user =
    { lib, ... }:
    let
      userName = "sergey";
      userDesc = "Сергей";
    in
    {
      options.preferences = {
        user.name = lib.mkOption {
          type = lib.types.str;
          default = "${userName}";
        };
      };

      config.users.users.${userName} = {
        isNormalUser = true;
        description = "${userDesc}";
        extraGroups = [
          "wheel"
        ];
      };
    };
}
