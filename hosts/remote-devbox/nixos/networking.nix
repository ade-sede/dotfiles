{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "remote-devbox";
  networking.networkmanager.enable = true;
}
