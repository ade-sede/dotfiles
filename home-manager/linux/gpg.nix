# GPG agent for Linux desktop — Qt pinentry, SSH support, smart card daemon, long SSH cache TTL.
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
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 86400;
    pinentry = {
      package = pkgs.pinentry-qt;
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
