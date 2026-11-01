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

      entryOf =
        path:
        let
          parts = lib.splitString "/" (rel path);
          top = builtins.head parts;
        in
        if lib.length parts == 1 then
          {
            name = lib.removeSuffix ".nix" top;
            direct = true;
          }
        else
          {
            name = top;
            direct = false;
          };

      grouped = builtins.foldl' (
        acc: path:
        let
          entry = entryOf path;
          current = acc.${entry.name} or {
            direct = entry.direct;
            files = [ ];
          };
        in
        acc // {
          ${entry.name} = current // {
            files = current.files ++ [ path ];
          };
        }
      ) { } files;

      asModule =
        _: group:
        if group.direct && lib.length group.files == 1 then
          import (builtins.head group.files)
        else
          { imports = group.files; };
    in
    lib.mapAttrs asModule grouped;
in
{
  flake.nixosModules = featureModules ./. "nixos";
  flake.homeModules = featureModules ./. "home";
}
