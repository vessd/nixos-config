{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./direnv.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    firefox
    thunderbird
    homebank
    keepassxc
    mpv
    qbittorrent
    telegram-desktop
    wireshark

    libreoffice-qt
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US

    bottom
    p7zip-rar
    ffmpeg
    yt-dlp

    zed-editor
    codebook
    nixd
    nixfmt
    nix-tree
  ];
}
