{ inputs, self, ... }:
let
  # заимствуем lib.activate/deployChecks у flake'а deploy-rs, но сам пакет
  # deploy-rs оставляем из nixpkgs
  deployRsOverlay = final: prev: {
    deploy-rs = prev.deploy-rs // {
      inherit (prev) deploy-rs;
      lib = (inputs.deploy-rs.overlays.default final prev).deploy-rs.lib;
    };
  };

  deployPkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [ deployRsOverlay ];
    };
in
{
  flake.deploy.nodes.nas =
    let
      nixos = self.nixosConfigurations.nas;
      deployPkgs = deployPkgsFor nixos.pkgs.stdenv.hostPlatform.system;
    in
    {
      hostname = "nas";
      profiles.system = {
        sshUser = "root";
        path = deployPkgs.deploy-rs.lib.activate.nixos nixos;
      };
    };

  perSystem =
    { system, ... }:
    {
      checks = (deployPkgsFor system).deploy-rs.lib.deployChecks self.deploy;
    };
}
