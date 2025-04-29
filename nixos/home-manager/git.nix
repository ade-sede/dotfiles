{
  config,
  pkgs,
  lib,
  ...
}: let
  userVars = import ./variables.nix;
in {
  programs.git = {
    enable = true;
    userName = userVars.userName;
    userEmail = userVars.userEmail;

    signing = {
      signByDefault = true;
      key = null;
    };

    aliases = {
      c = "commit -a";
      s = "status";
      d = "diff";
      p = "push";
      co = "checkout";
      tree = "log --all --pretty --oneline --graph";
      lolp = "log --graph --pretty=format:\"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%cr)%Creset %C(green)%ce%Creset %s\"";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      lolap = "log --graph --decorate --pretty=oneline --abbrev-commit --exclude='*prod*' --all";
      lolan = "log --graph --decorate --pretty=oneline --abbrev-commit --all --name-status";
    };

    extraConfig = {
      core = {
        askPass = "";
        excludesfile = "$HOME/gitignore";
      };
      user.useConfigOnly = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      credential."https://github.com".helper = "!/home/ade-sede/.nix-profile/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!/home/ade-sede/.nix-profile/bin/gh auth git-credential";
    };
  };
}
