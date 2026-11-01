{ pkgs, ... }:
{
  programs.git = {
    includes = [
      {
        condition = "gitdir:~/projects/stilsoft/**";
        contents.user.email = "veselkov_s@stilsoft.su";
      }
    ];
  };

  home.packages = [ pkgs.element-desktop ];
}
