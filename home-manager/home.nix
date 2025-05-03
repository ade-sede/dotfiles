{
  config,
  pkgs,
  username ? "ade-sede",
  homeDirectory ? "/home/ade-sede",
  ...
}: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  manual.manpages.enable = false;

  home.sessionVariables = {
    GPG_TTY = "$(tty)";
  };

  imports = [
    ./packages.nix
    ./dotfiles.nix
    ./programs.nix
    ./tmux.nix
    ./meme.nix
    ./desktop.nix
    ./activation.nix
    ./services.nix
  ];
}
