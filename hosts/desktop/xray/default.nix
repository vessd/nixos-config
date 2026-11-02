{ config, ... }: {
  age.secrets.xray-client.rekeyFile = ./xray-client.age;
  services.xray = {
    enable = true;
    settingsFile = config.age.secrets.xray-client.path;
  };
}
