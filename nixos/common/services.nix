{
  config,
  pkgs,
  lib,
  ...
}: {
  services.printing.enable = false;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
  };
}
