{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # sync pkg versions with `inputs.nixpkgs`
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      lanzaboote,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "sergey";
      userdesc = "Сергей";

      mkHost =
        {
          hostPath,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit username userdesc;
          };

          modules = [
            hostPath

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit username;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixos = mkHost {
          hostPath = ./hosts/desktop;
          extraModules = [
            lanzaboote.nixosModules.lanzaboote
          ];
        };

        nixos-lt = mkHost {
          hostPath = ./hosts/laptop;
        };
      };
    };
}
