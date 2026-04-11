{
  flake.homeModules.base = {
    programs.bash = {
      enable = true;
      historyFileSize = null;
      historyControl = [ "erasedups" ];
    };
  };
}
