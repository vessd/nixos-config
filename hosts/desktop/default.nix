{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };

    modules = [
      self.nixosModules.base
      self.nixosModules.docker
      self.nixosModules.kde
      self.nixosModules.perf
      self.nixosModules.pipewire
      self.nixosModules.user
      self.nixosModules.wireshark

      inputs.home-manager.nixosModules.home-manager
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.quadlet-nix.nixosModules.quadlet

      ./boot.nix
      ./configuration.nix
      ./hardware-configuration.nix
      ./home.nix
      ./networking.nix
      ./printer.nix
      ./work.nix
    ];
  };
}
