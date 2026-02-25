{
  programs.git = {
    enable = true;

    ignores = [
      ".vscode"
      ".zed"
      "*.docx"
      ".~lock*"
      "*.pdf"
      "*.bin"
    ];

    attributes = [ "Cargo.lock -diff" ];

    includes = [
      {
        condition = "gitdir:~/projects/stilsoft/**";
        contents.user.email = "veselkov_s@stilsoft.su";
      }
    ];

    settings = {
      user = {
        name = "Sergey Veselkov";
        email = "veselkovsd@yandex.ru";
      };
      push.autoSetupRemote = true;
    };
  };
}
