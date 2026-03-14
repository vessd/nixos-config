{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = [
      pkgs.cups-filters
      pkgs.cups-browsed
      pkgs.pantum-driver
    ];
  };

  services.saned.enable = true;
  environment.systemPackages = [
    pkgs.kdePackages.skanlite
  ];
}
