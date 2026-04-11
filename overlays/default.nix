{
  pkgs-unstable,
  yandex-browser-pkgs,
  ...
}:
[
  (final: prev: import ../pkgs { pkgs = final; })

  (final: prev: {
    # https://github.com/NixOS/nixpkgs/issues/424333
    docker = pkgs-unstable.docker;
    yandex-browser-stable = yandex-browser-pkgs.yandex-browser-stable;
  })
]
