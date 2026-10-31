{ inputs, ... }:
let
  pkgs-local = final: prev: import ../pkgs { pkgs = final; };
  pkgs-unstable =
    final: prev:
    let
      system = final.stdenv.hostPlatform.system;
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
    in
    {

    };
  llm-agents =
    final: prev:
    let
      system = final.stdenv.hostPlatform.system;
      llm-agents = inputs.llm-agents.packages.${system};
    in
    {
      kimi-code = llm-agents.kimi-code;
    };
in
{
  flake.nixosModules.base.nixpkgs.overlays = [
    pkgs-local
    pkgs-unstable
    llm-agents
  ];
}
