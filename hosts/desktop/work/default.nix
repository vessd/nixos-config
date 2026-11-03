{ pkgs, config, ... }:

{
  virtualisation.docker.daemon.settings = {
    insecure-registries = [ "192.168.202.252:5012" ];
  };

  age.secrets = {
    openvpn-config.rekeyFile = ./openvpn-config.age;
    openvpn-otp.rekeyFile = ./openvpn-otp.age;
  };

  services.openvpn.servers.stilsoft.config = ''
    config ${config.age.secrets.openvpn-config.path}

    auth-user-pass /run/openvpn-stilsoft/auth
    resolv-retry 0

    script-security 2
    up ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
    up-restart
    down ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
    down-pre
  '';

  systemd.services.openvpn-stilsoft = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    startLimitIntervalSec = 300;
    startLimitBurst = 5;

    preStart = ''
      umask 077
      ${pkgs.pritunl-openvpn-auth}/bin/pritunl-openvpn-auth \
        "${config.age.secrets.openvpn-config.path}" \
        "${config.age.secrets.openvpn-otp.path}" \
        > /run/openvpn-stilsoft/auth
    '';

    serviceConfig = {
      RestartSec = 15;
      ExecCondition = "${pkgs.is-weekday}/bin/is-weekday";
      RuntimeDirectory = "openvpn-stilsoft";
      RuntimeDirectoryMode = "0700";
    };
  };
}
