# koala-devbox-only packages — desktop apps not shared with other hosts (Signal, KiCad, Plex, etc.).
{pkgs, ...}: {
  home.packages = with pkgs; [
    signal-desktop
    kicad
    wl-clipboard
    plex-desktop
    qbittorrent
    plasma5Packages.kdeconnect-kde
    gnome-network-displays
  ];
}
