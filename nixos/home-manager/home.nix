{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ade-sede";
  home.homeDirectory = "/home/ade-sede";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment!

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
  ];
}
