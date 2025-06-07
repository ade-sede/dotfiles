{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "koala-devbox";
  networking.networkmanager.enable = true;
}
