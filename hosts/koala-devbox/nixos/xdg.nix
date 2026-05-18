# XDG portal config for koala-devbox — KDE portal, xdg-open via portal, and autostart.
{pkgs, ...}: {
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
    };
    autostart.enable = true;
  };
}
