{ pkgs, lib, ... }:
let
  appId = "ru.yandex.Browser";
in
{
  services.flatpak.packages = [ appId ];

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
