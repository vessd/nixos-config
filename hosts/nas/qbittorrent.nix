{
  users.groups.qbt = {
    gid = 968;
  };
  users.users.qbt = {
    isSystemUser = true;
    group = "qbt";
    uid = 968;
  };

  services.qbittorrent = {
    enable = true;
    user = "qbt";
    group = "qbt";
    profileDir = "/var/lib/qbittorrent";
    webuiPort = 8082;
    torrentingPort = 1725;
  };
}
