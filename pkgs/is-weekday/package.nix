{ writeShellScriptBin }:

writeShellScriptBin "is-weekday" ''
  [ $(date +%u) -le 5 ]
''
