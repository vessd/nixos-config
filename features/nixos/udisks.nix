{
  services.udisks2.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      const mountActions = [
        "org.freedesktop.udisks2.filesystem-mount",
        "org.freedesktop.udisks2.filesystem-mount-system",
        "org.freedesktop.udisks2.filesystem-mount-other-seat",
      ];

      if (subject.isInGroup("wheel") && mountActions.indexOf(action.id) !== -1) {
        return polkit.Result.YES;
      }
    });
  '';
}
