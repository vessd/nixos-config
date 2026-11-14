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
      inputs.home-manager.nixosModules.home-manager
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.quadlet-nix.nixosModules.quadlet
      inputs.agenix.nixosModules.default
      inputs.agenix-rekey.nixosModules.default
      inputs.nix-flatpak.nixosModules.nix-flatpak

      self.nixosModules.base
      self.nixosModules.docker
      self.nixosModules.flatpak
      self.nixosModules.kde
      self.nixosModules.perf
      self.nixosModules.pipewire
      self.nixosModules.udisks
      self.nixosModules.user
      self.nixosModules.wireshark

      ./agenix.nix
      ./boot.nix
      ./configuration.nix
      ./hardware-configuration.nix
      ./home.nix
      ./networking.nix
      ./printer.nix
      ./work
      ./xray
    ];
  };
}
