{ pkgs, ... }:

{
  virtualisation.docker.daemon.settings = {
    insecure-registries = [ "192.168.202.252:5012" ];
  };

  services.openvpn.servers.stilsoft.config = ''
    config /root/nixos/openvpn/stilsoft/ALL_veselkov_s_MAIN.ovpn
    auth-user-pass /root/nixos/openvpn/stilsoft/ALL_veselkov_s_MAIN.auth
    script-security 2
    up ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
    up-restart
    down ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
    down-pre
  '';

  systemd.services.openvpn-stilsoft = {
    preStart = ''
      PROFILE="/root/nixos/openvpn/stilsoft/ALL_veselkov_s_MAIN"
      ${pkgs.pritunl-openvpn-auth}/bin/pritunl-openvpn-auth "$PROFILE.ovpn" "$PROFILE.otp" > "$PROFILE.auth"
    '';
  };

  environment.systemPackages = [
    pkgs.update-systemd-resolved
    pkgs.pritunl-openvpn-auth
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
