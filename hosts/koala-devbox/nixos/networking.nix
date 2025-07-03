{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "koala-devbox";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # Steam Remote Play
      27036
      27037
    ];
    allowedUDPPorts = [
      # Steam Remote Play
      27031
      27036
      # Steam VR Streaming
      10400
      10401
    ];
  };
}
