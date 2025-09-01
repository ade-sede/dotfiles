{
  config,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    settings = {
      no-greeting = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    defaultCacheTtl = 0;
    defaultCacheTtlSsh = 0;
    maxCacheTtl = 0;
    maxCacheTtlSsh = 0;
    pinentry = {
      package = pkgs.pinentry-tty;
    };
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };
}