{ username, ... }:

{
  imports = [
    ./programs
    ./services
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
}
