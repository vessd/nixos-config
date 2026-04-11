{ pkgs, config, ... }:
{
  services.displayManager.sddm = {
    settings = {
      Autologin = {
        Session = "plasma.desktop";
        User = "${config.preferences.user.name}";
      };
    };
  };

  services.openssh.enable = true;
  virtualisation.quadlet.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.nix-ld.enable = true;
  # programs.assistant.enable = true;

  environment.systemPackages = [
    # для libvirt ?
    pkgs.dnsmasq
  ];
}
