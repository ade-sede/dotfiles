# Networking config for remote-devbox — hostname, NetworkManager, and open ports for SSH/HTTP/HTTPS/dev.
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
