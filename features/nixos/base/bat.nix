{
  flake.nixosModules.base = {
    programs.bat = {
      enable = true;
      settings = {
        style = "plain";
      };
    };
  };
}
