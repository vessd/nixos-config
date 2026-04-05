{
  networking.hostName = "msk-vps";
  networking.useDHCP = false;
  # networking.firewall.enable = false;

  systemd.network.enable = true;

  systemd.network.links."10-ens3-mac" = {
    matchConfig.OriginalName = "ens3";
    linkConfig.MACAddress = "52:54:00:2D:F7:B2";
  };

  systemd.network.networks."10-ens3" = {
    matchConfig.Name = "ens3";
    networkConfig = {
      Address = [ "178.236.245.206/24" ];
      Gateway = "178.236.245.254";
      DNS = [
        "8.8.8.8"
        "1.1.1.1"
      ];
    };
  };

  services.resolved.enable = true;

  networking.proxy.noProxy = "localhost,127.0.0.0/8";
}
