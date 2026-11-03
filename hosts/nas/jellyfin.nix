{ pkgs, ... }:
let
  uid = 970;
  gid = uid;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    # TODO: для qsv конфиг формируется неверно
    # фикс есть, но он не в stable
    # https://github.com/NixOS/nixpkgs/pull/562643
    forceEncodingConfig = false;

    hardwareAcceleration = {
      enable = true;
      type = "qsv";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      enableHardwareEncoding = true;
      enableIntelLowPowerEncoding = true;
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        hevc10bit = true;
        av1 = true;
      };
      hardwareEncodingCodecs = {
        hevc = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.intel-media-driver
      pkgs.vpl-gpu-rt
    ];
  };

  users.users.jellyfin = {
    uid = uid;
    extraGroups = [
      "render"
      "video"
    ];
  };

  users.groups.jellyfin.gid = gid;

  fileSystems."/var/cache/jellyfin/transcodes" = {
    fsType = "tmpfs";
    options = [
      "mode=0700"
      "uid=${toString uid}"
      "gid=${toString gid}"
    ];
  };

  systemd.services.jellyfin.unitConfig.RequiresMountsFor = [ "/var/cache/jellyfin/transcodes" ];
}
