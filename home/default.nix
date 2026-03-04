{ username, config, ... }:

{
  imports = [
    ./programs
    ./services
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    stateVersion = "25.11";
  };
}
