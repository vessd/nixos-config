{ config, ... }:
{
  programs.nh.flake = "/home/${config.preferences.user.name}/.config/nixos";

  services.displayManager.sddm = {
    settings = {
      Autologin = {
        Session = "plasma.desktop";
        User = config.preferences.user.name;
      };
    };
  };

  virtualisation.quadlet.enable = true;
  services.flatpak.enable = true;
  programs.nix-ld.enable = true;

  programs.steam.enable = true;
}
