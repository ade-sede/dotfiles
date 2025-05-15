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
