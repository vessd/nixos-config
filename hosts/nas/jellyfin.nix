{ pkgs, ... }:
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
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        hevc10bit = true;
        av1 = true;
      };
      hardwareEncodingCodecs = {
        hevc = true;
        av1 = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };

  users.users.jellyfin = {
    uid = 970;
    extraGroups = [
      "render"
      "video"
    ];
  };

  users.groups.jellyfin.gid = 970;
}
