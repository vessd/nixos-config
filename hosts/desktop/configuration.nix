{ config, ... }:
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
  programs.nix-ld.enable = true;

  virtualisation.vmware.host.enable = true;

  # programs.assistant.enable = true;
}
