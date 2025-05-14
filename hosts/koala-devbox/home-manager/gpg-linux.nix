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
    defaultCacheTtlSsh = 3600;
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