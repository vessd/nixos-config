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
  programs.steam.enable = true;
  services.flatpak.enable = true;

  services.udisks2.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("wheel") &&
        (
          action.id == "org.freedesktop.udisks2.filesystem-mount" ||
          action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
          action.id == "org.freedesktop.udisks2.filesystem-mount-other-seat"
        )
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  services.xray = {
    enable = true;
    settingsFile = "/home/sergey/.config/xray-core/config/client.json";
  };
}
