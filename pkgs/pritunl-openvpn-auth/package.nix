{
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "pritunl-openvpn-auth";
  version = "1.0.0";
  pyproject = false;

  src = ./src;

  dontBuild = true;
  doCheck = false;

  dependencies = with python3Packages; [
    pynacl
    pyotp
  ];

  installPhase = ''
    runHook preInstall

    install -D -m755 pritunl-openvpn-auth.py $out/bin/pritunl-openvpn-auth

    runHook postInstall
  '';

  meta = {
    description = "Python helper script for Pritunl totp auth";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
