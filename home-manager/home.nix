{
  config,
  pkgs,
  ...
}: {
  home.username = "ade-sede";
  home.homeDirectory = "/home/ade-sede";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [];

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
  ];
}
