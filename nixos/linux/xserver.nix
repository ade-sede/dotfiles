# Display server config for Linux — SDDM with Wayland, KDE Plasma 6, and US keyboard with compose key.
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:ralt";
  };
}
