{ pkgs, config, ... }:
{
  programs.distrobox = {
    enable = true;
    containers.debian-12 = {
      image = "quay.io/toolbx-images/debian-toolbox:12";
      home = "${config.home.homeDirectory}/.local/share/distrobox/debian-12/home";
      init = true;
      additional_packages = [
        "systemd libpam-systemd pipewire-audio-client-libraries"
        "nano"
        "libnss3 libgtk-3-0 libasound2"
      ];
    };
  };

  home.packages = [
    pkgs.xhost
  ];

  # https://distrobox.it/useful_tips/#resolve-error-cannot-open-display-0
  home.file.".distroboxrc".text = ''
    xhost +si:localuser:$USER > /dev/null
  '';

  xdg.desktopEntries = {
    syn5-app = {
      name = "Синергет 5";
      exec = "syn5-app";
      terminal = false;
      categories = [
        "Network"
      ];
    };

    syn5-app-dev = {
      name = "Синергет 5 (devtools)";
      exec = "syn5-app -devtools";
      terminal = false;
      categories = [
        "Network"
      ];
    };
  };
}
