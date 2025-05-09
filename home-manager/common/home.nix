{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  fullName,
  userEmail,
  ...
}: {
  imports = [
    ./packages.nix
    ./dotfiles.nix
    ./programs.nix
    ./tmux.nix
    ./meme.nix
    ./activation.nix
    ./services.nix
  ];

  config = {
    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = false;
    home.sessionVariables = {
      FULL_NAME = fullName;
      EMAIL = userEmail;
    };

    programs.home-manager.enable = true;

    manual.manpages.enable = false;
  };
}
