{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      lanzaboote,
      quadlet-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "sergey";
      userdesc = "Сергей";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
      };
      overlays = import ./overlays {
        inherit pkgs-unstable;
      };

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
            { nixpkgs.overlays = overlays; }

            hostPath

            # TODO: разделить home для каждого host
            quadlet-nix.nixosModules.quadlet

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./home;
                extraSpecialArgs = {
                  inherit username quadlet-nix;
                };
              };
            }
          ]
          ++ extraModules
          ++ import ./modules;
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

        msk-vps = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            { nixpkgs.overlays = overlays; }
            ./hosts/msk-vps
          ];
        };
      };
    };
}
