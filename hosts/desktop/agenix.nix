let
  cachePath = "/var/tmp/agenix-rekey";
in
{
  age.rekey = {
    hostPubkey = "/etc/ssh/ssh_host_ed25519_key.pub";
    masterIdentities = [ "~/.config/agenix/master-key.txt" ];
    storageMode = "derivation";
    cacheDir = "${cachePath}";
  };

  systemd.tmpfiles.rules = [
    "d ${cachePath} 1777 root root"
  ];

  # Эта настройка должна быть применена (через switch-to-configuration) до первого вызова
  # `agenix rekey`, иначе сборщик не получает доступа к `age.rekey.cacheDir` и не может
  # взять оттуда секреты:
  # > At least one rekeyed secret is missing, please run `agenix rekey` again.
  #
  # Если секреты уже добавлены, но настройка ещё не применена, временно запустите
  # `agenix rekey` от root. После того как конфиг применится, всё заработает и из-под
  # обычного пользователя.
  nix.settings.extra-sandbox-paths = [ "${cachePath}" ];
}
