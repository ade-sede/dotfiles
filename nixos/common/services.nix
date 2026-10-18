# Shared NixOS services — minimal overrides applied to all NixOS hosts (currently: printing disabled, journal capped).
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.printing.enable = false;

  services.journald.extraConfig = ''
    SystemMaxUse=500M
  '';
}
