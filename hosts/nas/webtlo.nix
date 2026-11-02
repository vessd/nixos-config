{
  virtualisation.quadlet.volumes.webtlo-data = { };

  virtualisation.quadlet.containers.webtlo = {
    containerConfig = {
      image = "docker.io/berkut174/webtlo:latest";
      autoUpdate = "registry";
      publishPorts = [ "8081:80" ];
      volumes = [ "webtlo-data:/data" ];
      environments = {
        WEBTLO_UID = "966";
        WEBTLO_GID = "966";
        WEBTLO_CRON = "false";
      };
    };

    unitConfig.RequiresMountsFor = [ "/storage" ];
  };
}
