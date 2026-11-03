{
  boot.loader.systemd-boot.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/HkpyL6xCZgJMfPI4xUOUdmixp0NIW/vuEtr6g1nqB veselkovsd@yandex.ru"
  ];

  virtualisation.quadlet.enable = true;
}
