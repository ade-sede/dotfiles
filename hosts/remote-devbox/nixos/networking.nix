{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "remote-devbox";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [22 80 443 3000];
}
