{
  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "ru.yandex.Browser"
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
