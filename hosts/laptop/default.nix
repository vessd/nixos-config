{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.nixos-lp = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.docker
      self.nixosModules.kde
      self.nixosModules.pipewire
      self.nixosModules.user

      inputs.home-manager.nixosModules.home-manager
      inputs.nix-flatpak.nixosModules.nix-flatpak

      ./configuration.nix
      ./hardware-configuration.nix
    ];
  };
}
