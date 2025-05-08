{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;
  home.sessionVariables = {
    GPG_TTY = "$(tty)";
  };

  programs.home-manager.enable = true;

  manual.manpages.enable = false;


  imports = [
    ./packages.nix
    ./dotfiles.nix
    ./programs.nix
    ./tmux.nix
    ./meme.nix
    ./activation.nix
    ./services.nix
  ];
}
