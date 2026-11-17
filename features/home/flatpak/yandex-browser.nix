let
  appId = "ru.yandex.Browser";
in
{
  services.flatpak.packages = [ appId ];

  # Фикс для Drag-and-drop файлов
  services.flatpak.overrides.settings.${appId}.Context.filesystems = [
    "home"
  ];

  # Фикс для китайских шрифтов
  #
  # rm -rf ~/.var/app/ru.yandex.Browser/cache/fontconfig
  # flatpak run --command=fc-cache ru.yandex.Browser -f -v
}
