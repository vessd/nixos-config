{
  flake.homeModules.xray =
    { config, ... }:
    {
      virtualisation.quadlet = {
        containers.xray-core = {
          autoStart = true;

          serviceConfig = {
            RestartSec = "30";
            Restart = "always";
          };

          containerConfig = {
            name = "xray-core";
            image = "ghcr.io/xtls/xray-core:26.2.6";

            publishPorts = [
              "1080:1080"
              "2080:2080"
            ];

            volumes = [ "${config.home.homeDirectory}/.config/xray-core/config:/usr/local/etc/xray" ];
          };
        };
      };
    };
}
