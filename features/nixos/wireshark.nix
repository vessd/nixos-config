{
  flake.nixosModules.wireshark =
    {
      lib,
      config,
      ...
    }:
    let
      user = lib.attrByPath [ "preferences" "user" "name" ] null config;
    in
    {
      programs.wireshark.enable = true;
      users.extraGroups.wireshark.members = lib.optional (user != null) user;
    };
}
