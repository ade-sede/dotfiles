{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vim
    wget
    nodejs
    git
    tmux
    ghostty
    vivaldi
    discord
    starship
    curl
    fzf
    python3
    python311Packages.pip
    eza
    github-cli
    bat
    coreutils
    gnugrep
    gawk
    findutils
    cmake
    gnumake
    gcc
  ];
}
