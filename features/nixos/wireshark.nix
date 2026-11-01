{
  lib,
  config,
  ...
}:
let
  user = config.preferences.user.name or null;
in
{
  programs.wireshark.enable = true;
  users.extraGroups.wireshark.members = lib.optional (user != null) user;
}
