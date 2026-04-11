{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # дедупликация зависимостей ?
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.inputs.flake-compat.follows = "flake-compat";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    yandex-browser-nix = {
      url = "github:miuirussia/yandex-browser.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./overlays

        inputs.home-manager.flakeModules.home-manager

        (inputs.import-tree ./features)

        ./hosts/desktop
        ./hosts/laptop
        ./hosts/msk-vps
      ];
    };
}
