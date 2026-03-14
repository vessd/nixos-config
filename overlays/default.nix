{
  pkgs-unstable,
  ...
}:
[
  (final: prev: import ../pkgs { pkgs = final; })

  (final: prev: {
    # https://github.com/NixOS/nixpkgs/issues/424333
    docker = pkgs-unstable.docker;
    # https://github.com/NixOS/nixpkgs/issues/478154
    distrobox = pkgs-unstable.distrobox;
  })
]
