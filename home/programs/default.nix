{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    firefox
    thunderbird
    homebank
    keepassxc
    mpv
    qbittorrent
    pavucontrol
    telegram-desktop
    wireshark

    libreoffice-qt
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US

    bottom
    p7zip-rar
    docker-compose
    docker-buildx
    ffmpeg
    shadowsocks-rust
    yt-dlp

    zed-editor
    codebook
    nixd
    nixfmt
  ];
}
