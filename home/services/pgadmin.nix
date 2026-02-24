{
  virtualisation.quadlet.containers.pgadmin = {
    autoStart = true;
    serviceConfig = {
      RestartSec = "30";
      Restart = "on-failure";
    };
    containerConfig = {
      name = "pgadmin";
      image = "docker.io/dpage/pgadmin4:latest";
      autoUpdate = "registry";

      environments = {
        PGADMIN_DEFAULT_EMAIL = "admin@example.com";
        PGADMIN_DEFAULT_PASSWORD = "admin";
        PGADMIN_CONFIG_SERVER_MODE = "False";
        PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED = "False";
        PGADMIN_CONFIG_UPGRADE_CHECK_ENABLED = "False";
      };

      publishPorts = [ "8081:80" ];
      volumes = [ "pgadmin-data:/var/lib/pgadmin" ];
    };
  };

  virtualisation.quadlet.volumes.pgadmin-data = { };
}
