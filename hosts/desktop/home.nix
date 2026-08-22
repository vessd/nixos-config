{
  self,
  inputs,
  config,
  ...
}:
let
  userName = config.preferences.user.name;
  homeDir = "/home/${userName}";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = {
      imports = [
        inputs.quadlet-nix.homeManagerModules.quadlet

        self.homeModules.base
        self.homeModules.pgadmin
        self.homeModules.work
        self.homeModules.yandex-disk
      ];

      home = {
        username = "${userName}";
        homeDirectory = "${homeDir}";
        sessionPath = [
          "${homeDir}/.local/bin"
        ];
        stateVersion = "25.11";
      };
    };
    extraSpecialArgs = {
      inherit self;
    };
  };
}
