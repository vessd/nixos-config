{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  services.openssh = {
    enable = true;
    ports = [ 46826 ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/HkpyL6xCZgJMfPI4xUOUdmixp0NIW/vuEtr6g1nqB veselkovsd@yandex.ru"
  ];

  services.qemuGuest.enable = true;

  environment.systemPackages = [
    pkgs.openssl
  ];
}
