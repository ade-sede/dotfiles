# Fun/cosmetic CLI packages installed on every host (cowsay, neofetch, etc.).
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
    neofetch
  ];
}
