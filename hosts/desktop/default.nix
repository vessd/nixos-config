{ username, ... }:

{
  imports = [
    ./boot.nix
    ./docker.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./openvpn.nix
    ./printer.nix
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
