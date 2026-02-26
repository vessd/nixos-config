{ pkgs, ... }:

{
  services.openssh.enable = true;
  services.printing.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.quadlet.enable = true;
  services.flatpak.enable = true;

  virtualisation.virtualbox.host.enable = true;
  # frequent recompilation
  # virtualisation.virtualbox.host.enableExtensionPack = true;

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

  environment.systemPackages = [
    pkgs.ncdu
    pkgs.ripgrep
    pkgs.fd
    # https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/636
    pkgs.pulseaudio
  ];
}
