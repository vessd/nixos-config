{
  networking.hostName = "nixos";
  networking.useDHCP = false;

  systemd.network.enable = true;
  systemd.network.networks."lan" = {
    matchConfig = {
      Type = "ether";
    };

    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };
  };

  services.resolved.enable = true;

  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.noProxy = "127.0.0.0/8,localhost,192.168.1.0/24";
}
