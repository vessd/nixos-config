{
  writers,
  symlinkJoin,
  installShellFiles,
}:

let
  bin = writers.writePython3Bin "jellyfin-link" {
    doCheck = false;
  } (builtins.readFile ./src/jellyfin_link.py);
in
symlinkJoin {
  name = "jellyfin-link";
  paths = [ bin ];
  nativeBuildInputs = [ installShellFiles ];
  postBuild = ''
    installShellCompletion --bash --name jellyfin-link ${./completions/jellyfin-link.bash}
  '';
}
