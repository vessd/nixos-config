{ pkgs, ... }:
{
  home.packages = [
    pkgs.distrobox
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
