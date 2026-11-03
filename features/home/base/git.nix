{
  programs.git = {
    enable = true;

    ignores = [
      ".vscode"
      ".zed"
      "*.docx"
      "*.odt"
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
