{ pkgs, ... }:
let
  is-weekday = pkgs.writeShellScript "is-weekday.sh" ''
    [ $(date +%u) -le 5 ]
  '';
in
{
  environment.systemPackages = [
    pkgs.update-systemd-resolved
  ];

  services.openvpn.servers.stilsoft.config = ''
    config /root/nixos/openvpn/stilsoft/ALL_veselkov_s_MAIN.ovpn

    auth-user-pass /root/nixos/openvpn/stilsoft/ALL_veselkov_s_MAIN.auth
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
      PROFILE="/root/nixos/openvpn/stilsoft/ALL_veselkov_s_MAIN"
      ${pkgs.pritunl-openvpn-auth}/bin/pritunl-openvpn-auth "$PROFILE.ovpn" "$PROFILE.otp" > "$PROFILE.auth"
    '';

    serviceConfig = {
      RestartSec = 15;
      ExecCondition = "${is-weekday}";
    };
  };
}
