{
  self,
  inputs,
  config,
  pkgs,
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
        inputs.nix-flatpak.homeManagerModules.nix-flatpak

        self.homeModules.base
        self.homeModules.flatpak
        self.homeModules.pgadmin
        self.homeModules.yandex-disk

        ./work/home.nix
      ];

      home = {
        username = "${userName}";
        homeDirectory = "${homeDir}";
        sessionPath = [
          "${homeDir}/.local/bin"
        ];
        stateVersion = "25.11";

        packages = with pkgs; [
          homebank
          quickemu
          claude-code
          kimi-code
        ];
      };
    };
    extraSpecialArgs = {
      inherit self;
    };
  };
}
