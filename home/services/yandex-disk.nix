{ pkgs, config, ... }:

{
  home.packages = [
    pkgs.yandex-disk
    pkgs.killall
  ];

  home.file.".config/yandex-disk/config.cfg".text = ''
    auth="${config.home.homeDirectory}/.config/yandex-disk/passwd"
    dir="${config.home.homeDirectory}/yandex.disk"
    proxy="no"
  '';

  systemd.user.services.yandex-disk = {
    Unit = {
      Description = "Yandex-Disk service";
      After = [ "local-fs.target network.target" ];
    };

    Service = {
      Type = "forking";
      ExecStart = "${pkgs.yandex-disk}/bin/yandex-disk start -c ${config.home.homeDirectory}/.config/yandex-disk/config.cfg";
      ExecReload = "${pkgs.killall}/bin/killall -qw yandex-disk";
      RestartSec = 30;
      Restart = "always";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
