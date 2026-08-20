# SSH and GPG base config — SSH match blocks, GPG settings, and activation to wake gpg-agent and cache the SSH key.
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.openssh];
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };

      "devbox.ade-sede.dev" = {
        User = "ade-sede";
        LocalForward = [
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

      devbox = {
        HostName = "devbox.ade-sede.dev";
        User = "ade-sede";
        ForwardX11 = true;
        ForwardX11Trusted = true;
        LocalForward = [
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

      steamdeck = {
        HostName = "192.168.1.177";
        User = "deck";
      };
    };
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
}
