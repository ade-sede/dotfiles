{
  config,
  pkgs,
  ...
}: let
  userVars = import ./variables.nix;
in {
  imports = [
    ./git.nix
    ./fish.nix
    ./ssh-gpg.nix
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "GitHub";
        style = "plain";
        pager = "less -FR";
      };
    };

    neovim = {
      enable = false;
    };

    starship = {
      enable = true;
    };
  };

  home.enableNixpkgsReleaseCheck = false;
}
