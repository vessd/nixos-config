{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  gtk2,
  libpulseaudio,
  libxtst,
  pipewire,
  sqlite,
  efivar,
  v4l-utils,
}:

stdenvNoCC.mkDerivation {
  pname = "assistant";
  version = "6.5.0";

  src = fetchurl {
    url = "https://xn--80akicokc0aablc.xn--p1ai/%D1%81%D0%BA%D0%B0%D1%87%D0%B0%D1%82%D1%8C/Download/1375";
    hash = "sha256-Rk2cjRn4XE0l2dibyII86xTUFmDNHX1uoEszMZsbGqY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    alsa-lib
    gtk2
    libpulseaudio
    libxtst
    pipewire
    sqlite
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/opt/assistant/scripts

    cp -r opt/assistant/{bin,lang} $out/opt/assistant/
    cp -r --no-dereference opt/assistant/lib $out/opt/assistant/
    cp opt/assistant/scripts/{assistant.sh,runasts.sh} $out/opt/assistant/scripts/

    ln -s $out/opt/assistant/scripts/assistant.sh $out/bin/assistant
    install -D -m644 opt/assistant/license/License.rtf $out/share/licenses/assistant/License.rtf
    install -D -m644 opt/assistant/share/icons/assistant.png $out/share/icons/hicolor/256x256/apps/assistant.png
    install -D -m644 opt/assistant/scripts/assistant.desktop $out/share/applications/assistant.desktop
    install -D -m644 opt/assistant/scripts/assistant.service $out/lib/systemd/system/assistant.service

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace \
        $out/lib/systemd/system/assistant.service \
        $out/opt/assistant/scripts/assistant.sh \
        $out/opt/assistant/scripts/runasts.sh \
        --replace-fail /opt/ $out/opt/

    substituteInPlace $out/opt/assistant/scripts/runasts.sh \
        --replace-fail 'DAEMON_LOG=$INST_DIR"/log/daemon.log"' DAEMON_LOG="/var/log/assistant-daemon.log"

    substituteInPlace $out/share/applications/assistant.desktop \
        --replace-fail Exec=/opt/assistant/scripts/assistant.sh Exec=assistant \
        --replace-fail Icon=/opt/assistant/share/icons/assistant.png Icon=assistant

    # удаляем распаковынные либы, иначе autoPatchelfHook будет на них ссылаться
    rm -rf opt/assistant/lib

    rm -f $out/opt/assistant/lib/libudev.so
  '';

  runtimeDependencies = map lib.getLib [
    efivar
    v4l-utils
  ];

  dontStrip = true;

  meta = {
    description = "Secure remote access to computers over a local network or over the Internet";
    homepage = "https://xn--80akicokc0aablc.xn--p1ai/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
