{
  networking.hostName = "nixos";
  networking.useDHCP = false;
  networking.firewall.enable = false;

  systemd.network.enable = true;
  systemd.network.networks."10-lan" = {
    matchConfig = {
      Name = "enp14s0";
    };

    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };

    dhcpV4Config = {
      RouteMetric = 200;
    };

    ipv6AcceptRAConfig = {
      RouteMetric = 200;
    };
  };

  # конфигурация для раздачи интернета с телефона
  systemd.network.networks."80-usb" = {
    matchConfig = {
      Name = "enp16s0u10";
    };

    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };

    dhcpV4Config = {
      RouteMetric = 100;
    };

    ipv6AcceptRAConfig = {
      RouteMetric = 100;
    };
  };

  services.resolved.enable = true;

  networking.proxy.noProxy = "localhost,127.0.0.0/8,192.168.1.0/24";

  environment.etc.hosts.enable = false;
}
