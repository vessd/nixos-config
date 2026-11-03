{ pkgs, ... }: {
  home.packages = [
    pkgs.firefox
    pkgs.thunderbird
    pkgs.element-desktop
    pkgs.wireshark
    pkgs.kdePackages.krdc
  ];

  programs.git = {
    includes = [
      {
        condition = "gitdir:~/projects/stilsoft/**";
        contents.user.email = "veselkov_s@stilsoft.su";
      }
    ];
  };
}
