{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      inherit (lib.fileset) toList fileFilter;

      isNixModule = file: file.hasExt "nix";
      importTree = path: toList (fileFilter isNixModule path);
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./overlays

        inputs.home-manager.flakeModules.home-manager

        ./hosts/desktop
        ./hosts/laptop
      ]
      ++ importTree ./features;
    };
}
