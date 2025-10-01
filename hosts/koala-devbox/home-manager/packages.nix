{pkgs, ...}: {
  home.packages = with pkgs; [
    signal-desktop
    kicad
    wl-clipboard
    plex-desktop
    qbittorrent
    plasma5Packages.kdeconnect-kde
  ];
}
