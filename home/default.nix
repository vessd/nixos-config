{ ... }:

{
  imports = [
    ./packages.nix
    ./configs
  ];

  home = {
    username = "sergey";
    homeDirectory = "/home/sergey";
    stateVersion = "25.11";
  };

}
