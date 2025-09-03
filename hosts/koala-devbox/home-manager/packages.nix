{pkgs, ...}: {
  home.packages = with pkgs; [
    signal-desktop
    kicad
    wl-clipboard
    plex-desktop
  ];
}
