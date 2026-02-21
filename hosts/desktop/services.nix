{ pkgs, ... }:

{
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
