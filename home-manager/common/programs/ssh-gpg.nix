{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.openssh];
  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_ed25519";
    };

    matchBlocks."devbox.ade-sede.dev" = {
      user = "ade-sede";
      localForwards = [
        {
          bind.port = 8080;
          host.address = "127.0.0.1";
          host.port = 8080;
        }
        {
          bind.port = 3000;
          host.address = "127.0.0.1";
          host.port = 3000;
        }
      ];
    };

    matchBlocks."devbox" = {
      hostname = "devbox.ade-sede.dev";
      user = "ade-sede";
      forwardX11 = true;
      forwardX11Trusted = true;
      localForwards = [
        {
          bind.port = 8080;
          host.address = "127.0.0.1";
          host.port = 8080;
        }
        {
          bind.port = 3000;
          host.address = "127.0.0.1";
          host.port = 3000;
        }
      ];
    };

    matchBlocks."steamdeck" = {
      hostname = "192.168.1.177";
      user = "deck";
    };

    extraConfig = ''
      AddKeysToAgent yes
    '';

    userKnownHostsFile = "~/.ssh/known_hosts";
  };

  programs.gpg = {
    settings = {
      no-greeting = true;
    };
  };

  home.activation = {
    setupGpgSsh = lib.hm.dag.entryAfter ["writeBoundary"] ''
      GPG_CONNECT_AGENT="${pkgs.gnupg}/bin/gpg-connect-agent"
      SSH_ADD="${pkgs.openssh}/bin/ssh-add"

      $DRY_RUN_CMD $GPG_CONNECT_AGENT /bye

      if [ -f ~/.ssh/id_ed25519 ]; then
        $DRY_RUN_CMD $SSH_ADD ~/.ssh/id_ed25519 || true
      fi
    '';
  };

  home.sessionVariables = {
    GPG_TTY = "$(tty)";
  };
}
