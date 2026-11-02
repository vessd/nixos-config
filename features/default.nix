{ lib, ... }:
let
  inherit (lib.fileset) toList fileFilter;

  nixFiles = dir: toList (fileFilter (f: f.hasExt "nix" && !lib.hasPrefix "_" f.name) dir);

  # правила сопоставления путь -> имя модуля:
  #   <kind>/<name>.nix    -> модуль <name>
  #   <kind>/<name>/*.nix  -> модуль <name> (файлы объединяются)
  featureModules =
    root: kind:
    let
      dir = root + "/${kind}";
      files = nixFiles dir;

      rel = path: lib.removePrefix "${toString dir}/" (toString path);
      nameOf = path: lib.removeSuffix ".nix" (lib.head (lib.splitString "/" (rel path)));

      grouped = lib.groupBy nameOf files;

      asModule =
        _: paths:
        if lib.length paths == 1 && !lib.hasInfix "/" (rel (lib.head paths)) then
          import (lib.head paths)
        else
          { imports = paths; };
    in
    lib.mapAttrs asModule grouped;
in
{
  flake.nixosModules = featureModules ./. "nixos";
  flake.homeModules = featureModules ./. "home";
}
