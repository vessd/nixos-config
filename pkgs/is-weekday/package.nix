{ writeShellScriptBin }:

writeShellScriptBin "is-weekday" ''
  [ -e /run/force-weekday ] || [ "$(date +%u)" -le 5 ]
''
