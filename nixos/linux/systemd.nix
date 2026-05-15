# systemd settings for Linux hosts — reduced timeouts, disabled network-online wait, and dbus burst limit.
{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd = {
    extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=10s
      DefaultStartLimitIntervalSec=10s
      DefaultStartLimitBurst=5
    '';

    network.wait-online.enable = false;
    user.services.dbus.startLimitBurst = 500;
  };
}
