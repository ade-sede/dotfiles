# Self-contained Home Manager config for pancho on remote-devbox — shares nothing with ade-sede's config.
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "pancho";
  home.homeDirectory = "/home/pancho";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.vim.enable = true;

  home.packages = with pkgs; [
    coreutils
    curl
    wget
    git
    jq
    ripgrep
    fd
    tree
    htop
    tmux
    unzip
    zip
  ];
}
