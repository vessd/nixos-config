{ inputs, ... }:
let
  pkgs-local = final: prev: import ../pkgs { pkgs = final; };
  pkgs-unstable =
    final: prev:
    let
      system = final.stdenv.hostPlatform.system;
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      pkgs-yandex-browser = inputs.yandex-browser-nix.packages.${system};
    in
    {
      # https://github.com/NixOS/nixpkgs/issues/424333
      docker = pkgs-unstable.docker;
      yandex-browser-stable = pkgs-yandex-browser.yandex-browser-stable;
    };
in
{
  flake.nixosModules.base.nixpkgs.overlays = [
    pkgs-local
    pkgs-unstable
  ];
}
