{
  # users.mutableUsers = false;

  users.users.sergey = {
    isNormalUser = true;
    description = "Сергей";
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
}
