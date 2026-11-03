{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.nas = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };

    modules = [
      inputs.quadlet-nix.nixosModules.quadlet
      inputs.disko.nixosModules.disko

      self.nixosModules.base

      ./configuration.nix
      ./disko.nix
      ./hardware-configuration.nix
      ./jellyfin.nix
      ./networking.nix
      ./qbittorrent.nix
      ./webtlo.nix
    ];
  };
}
