{
  networking.hostName = "nixos-lt";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
}
