{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 21d";
  };

  environment.variables = {
    # use elevation without password prompt for remote hosts with NOPASSWD configured
    NH_ELEVATION_STRATEGY = "passwordless";
  };

  # environment.systemPackages = [
  #   pkgs.nix-output-monitor
  #   pkgs.dix
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
