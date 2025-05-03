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
      enable = true;
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
      '';

      userKnownHostsFile = "~/.ssh/known_hosts";
    };

    gpg = {
      enable = true;
      settings = {
        no-greeting = true;
        pinentry-mode = "loopback";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  home.enableNixpkgsReleaseCheck = false;
}
