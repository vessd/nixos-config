{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # sudo sbctl create-keys
  # sudo sbctl enroll-keys --microsoft
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
