{
  flake.homeModules.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        firefox
        thunderbird
        homebank
        keepassxc
        mpv
        qbittorrent
        telegram-desktop

        libreoffice-qt
        hunspell
        hunspellDicts.ru_RU
        hunspellDicts.en_US
        corefonts

        bottom
        unrar
        ffmpeg
        yt-dlp

        zed-editor
        codebook
        nixd
        nixfmt
        nix-tree
      ];
    };
}
