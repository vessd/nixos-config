{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./direnv.nix
  ];

  # programs.firefox.enable = true;
  # programs.thunderbird.enable = true;

  home.packages = with pkgs; [
    firefox
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
    ffmpeg
    shadowsocks-rust
    yt-dlp

    zed-editor
    codebook
    nixd
    nixfmt
  ];
}
