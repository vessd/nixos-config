{ username, userdesc, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "${userdesc}";
    extraGroups = [
      "wheel"
      "docker"
      "vboxusers"
      "libvirtd"
    ];
  };
}
