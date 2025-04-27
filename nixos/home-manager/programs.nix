{ config, pkgs, ... }:

let
  userVars = import ./variables.nix;
in

{
  imports = [
    ./git.nix
  ];

  programs = {
    fish = {
      enable = true;
      
      plugins = [
        {
          name = "bass";
          src = pkgs.fetchFromGitHub {
            owner = "edc";
            repo = "bass";
            rev = "2fd3d2157d5271ca3575b13daec975ca4c10728a";
            sha256 = "0mb01y1d0g8ilsr5m8a71j6xmqlyhf8w4xjf00wkk8k41cz3ypky";
          };
        }
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
      ];
      
      shellInit = ''
        source ~/.dotfiles/dotfiles/fish/config.fish
      '';
    };

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
    pinentryPackage = pkgs.pinentry-curses;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  home.activation = {
    createDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.ssh
    '';
    
    generateSSHKey = config.lib.dag.entryAfter ["createDirs"] ''
      if [ ! -f ~/.ssh/id_ed25519 ]; then
        $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "${userVars.userEmail}"
      fi
    '';

    generateGPGKey = config.lib.dag.entryAfter ["createDirs"] ''
      if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys | grep -q "${userVars.userEmail}"; then
        $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg --batch --passphrase "" --quick-generate-key "${userVars.userName} <${userVars.userEmail}>" ed25519 sign never
      fi
    '';
  };
}
