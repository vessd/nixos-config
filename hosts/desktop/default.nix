{ username, ... }:

{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./services.nix
    ../../system
  ];

  services.displayManager.sddm = {
    wayland.enable = true;
    settings = {
      Autologin = {
        Session = "plasma.desktop";
        User = "${username}";
      };
    };
  };
}
