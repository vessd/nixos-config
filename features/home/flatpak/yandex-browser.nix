{ pkgs, lib, ... }:
let
  appId = "ru.yandex.Browser";
in
{
  services.flatpak.packages = [ appId ];

  # Drag-and-drop файлов из Dolphin в flatpak-приложение не работает "из коробки":
  # современный Dolphin (KDE/Qt с поддержкой портала FileTransfer) при перетаскивании
  # в сэндбокс-приложение предлагает файл только через org.freedesktop.portal.FileTransfer,
  # а Chromium (и он же под капотом у Yandex Browser) этот портал не реализует —
  # поддерживается только FileChooser (диалог "Открыть файл"). В результате drop
  # не содержит ничего пригодного для Chromium, и перетаскивание молча не срабатывает.
  # Единственный практический фикс — дать приложению прямой доступ к $HOME, тогда
  # Dolphin дополнительно включает в drag сырой host-путь, который Chromium может
  # открыть напрямую (без портала).
  #
  # https://github.com/flathub/com.google.Chrome/issues/267
  services.flatpak.overrides.settings.${appId}.Context.filesystems = [
    "home"
  ];

  # Chromium внутри flatpak-песочницы видит и матчит хостовые шрифты через
  # fontconfig (/run/host/fonts) нормально, но его собственный внутренний
  # сэндбокс рендерера не может прочитать данные глифов оттуда — в результате
  # CJK-текст занимает правильную ширину, но рисуется полностью невидимым (ни
  # один шрифт, ни variable, ни статический, значения не имеет). Решение —
  # положить шрифт в собственную "доверенную" директорию приложения
  # ~/.var/app/<id>/data/fonts, которую Chromium читает без проблем.
  #
  # Важно: должна быть РЕАЛЬНАЯ копия файла, а не symlink. Chromium отказывается
  # читать и symlink, ведущий обратно в /nix/store (тот же путь, что и у
  # /run/host/fonts) — поэтому home.file здесь не подходит, так как home-manager
  # всегда делает symlink.
  home.activation.yandexBrowserCjkFont = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD install -D -m644 \
      "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk/NotoSansCJK-VF.otf.ttc" \
      "$HOME/.var/app/${appId}/data/fonts/NotoSansCJK-VF.otf.ttc"
  '';
}
