# Fun/cosmetic CLI packages installed on every host (cowsay, fastfetch, etc.).
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    cbonsai
    cowsay
    lolcat
    fortune
    figlet
    toilet
    cmatrix
    sl
    asciiquarium
    nyancat
    boxes
    doge
    fastfetch
  ];
}
