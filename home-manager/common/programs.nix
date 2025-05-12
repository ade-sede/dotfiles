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

    ssh = {
      enable = true;
      matchBlocks."*" = {
        identityFile = "~/.ssh/id_ed25519";
      };

      extraConfig = ''
        AddKeysToAgent yes
        IdentityAgent "~/.gnupg/S.gpg-agent.ssh"
      '';

      userKnownHostsFile = "~/.ssh/known_hosts";
    };

  };

  home.enableNixpkgsReleaseCheck = false;
}
