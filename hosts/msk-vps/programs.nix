{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 46826 ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/HkpyL6xCZgJMfPI4xUOUdmixp0NIW/vuEtr6g1nqB veselkovsd@yandex.ru"
  ];

  virtualisation.docker = {
    enable = true;
    extraPackages = [
      pkgs.docker-compose
      pkgs.docker-buildx
    ];
  };

  services.qemuGuest.enable = true;

  programs.nano = {
    enable = true;
    nanorc = ''
      set autoindent
      set tabsize 4
      set tabstospaces
      set linenumbers
    '';
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
    };
  };

  programs.bat.enable = true;

  environment.systemPackages = [
    pkgs.ncdu
    pkgs.ripgrep
    pkgs.fd
    pkgs.dig
    pkgs.openssl
  ];
}
