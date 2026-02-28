{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.assistant;
in
{
  options.programs.assistant = {
    package = lib.mkPackageOption pkgs "assistant" { };
    enable = lib.mkEnableOption "Secure remote access to computers over a local network or over the Internet";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    environment.etc."assistant/cert/ca-bundle.crt".source = "${config.security.pki.caBundle}";

    # TODO: в service из deb пакета указан root,
    # но по факту больше похоже, что ожидается работа от имени пользователя
    #
    # users.users.assistant = {
    #   isSystemUser = true;
    #   group = "assistant";
    #   description = "Assistant service user";
    #   home = "/var/lib/assistant";
    #   createHome = true;
    # };
    # users.groups.assistant = { };

    # systemd.services.assistant = {
    #   description = "Assistant remote control unit";
    #   # wantedBy = [ "multi-user.target" ];
    #   after = [ "network-online.target" ];
    #   wants = [ "network-online.target" ];

    #   serviceConfig = {
    #     Type = "simple";
    #     User = "assistant";
    #     Group = "assistant";

    #     ExecStart = "${cfg.package}/opt/assistant/bin/asts";

    #     WorkingDirectory = "${cfg.package}/opt/assistant";

    #     Restart = "always";
    #     RestartSec = 3;
    #     TimeoutSec = 300;
    #   };
    # };
  };
}
