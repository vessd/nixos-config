{ pkgs, ... }:

{
  services.openssh.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;

  virtualisation.docker = {
    enable = true;
    extraPackages = [
      pkgs.docker-compose
      pkgs.docker-buildx
    ];
  };
  virtualisation.quadlet.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;
  };

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
  programs.nix-ld.enable = true;

  # programs.assistant.enable = true;
  # programs.amnezia-vpn.enable = true;

  environment.systemPackages = [
    pkgs.ncdu
    pkgs.ripgrep
    pkgs.fd
    pkgs.dig
    # для libvirt ?
    pkgs.dnsmasq
    # https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/636
    pkgs.pulseaudio
  ];
}
