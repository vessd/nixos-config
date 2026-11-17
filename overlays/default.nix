{ inputs, ... }:
let
  local = final: prev: import ../pkgs { pkgs = final; };
  unstable-picks =
    final: prev:
    let
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        # config.allowUnfree = true;
      };
    in
    {
      # jellyfin = pkgs-unstable.jellyfin;
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
    local
    unstable-picks
    llm-agents
  ];
}
