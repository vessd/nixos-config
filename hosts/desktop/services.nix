{ pkgs, ... }:

{
  virtualisation.docker.daemon.settings = {
    insecure-registries = [ "192.168.202.252:5012" ];
  };

  environment.systemPackages = [
    pkgs.update-systemd-resolved
    pkgs.pritunl-client
    pkgs.cotp
  ];

  systemd = {
    packages = [ pkgs.pritunl-client ];
    targets = {
      multi-user = {
        wants = [ "pritunl-client.service" ];
      };
    };
  };
}
