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
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    pinentry = {
      package = pkgs.pinentry-curses;
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