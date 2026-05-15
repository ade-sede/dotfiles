# Linux-only packages shared across all Linux hosts (currently: iotop).
{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    iotop
  ];
}
