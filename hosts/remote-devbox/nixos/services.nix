{
  config,
  pkgs,
  lib,
  ...
}: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
  };

  users.mutableUsers = true;
}
