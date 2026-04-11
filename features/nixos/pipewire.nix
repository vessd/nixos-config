{
  flake.nixosModules.pipewire =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        # alsa.support32Bit = true;
        pulse.enable = true;
      };

      environment.systemPackages = [
        # https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/636
        pkgs.pulseaudio
      ];
    };
}
