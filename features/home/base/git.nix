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

    settings = {
      user = {
        name = "Sergey Veselkov";
        email = "veselkovsd@yandex.ru";
      };
      push.autoSetupRemote = true;
    };
  };
}
