{
  config,
  pkgs,
  lib,
  ...
}: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  users.mutableUsers = true;

  users.users.ade-sede.initialPassword = "changeme";
}
