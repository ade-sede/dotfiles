{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  fullName,
  userEmail,
  theme,
  ...
}: {
  imports = [
    # Programs
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/ssh-gpg.nix
    ./programs/starship.nix
    ./programs/tmux.nix

    # Other Configs
    ./packages.nix
    ./dotfiles.nix
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
    news.display = "silent";

    manual.manpages.enable = false;
  };
}
