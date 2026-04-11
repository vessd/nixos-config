{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.msk-vps = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.docker

      ./configuration.nix
      ./hardware-configuration.nix
      ./networking.nix
    ];
  };
}
