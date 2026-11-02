{ ... }:
{
  networking.hostName = "nas";
  networking.useDHCP = false;
  networking.firewall.enable = false;

  systemd.network.enable = true;
  systemd.network.networks."20-primary" = {
    matchConfig.Name = "enp2s0";
    linkConfig.RequiredForOnline = "routable";
    networkConfig.DHCP = "yes";
    dhcpV4Config.RouteMetric = 100;
    ipv6AcceptRAConfig.RouteMetric = 100;
  };
  systemd.network.networks."30-secondary" = {
    matchConfig.Name = "enp3s0";
    linkConfig.RequiredForOnline = "no";
    networkConfig.DHCP = "yes";
    dhcpV4Config = {
      RouteMetric = 200;
      UseDNS = false;
    };
  };

  services.resolved.enable = true;
}
