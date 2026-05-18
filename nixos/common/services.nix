# Shared NixOS services — minimal overrides applied to all NixOS hosts (currently: printing disabled).
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.printing.enable = false;
}
