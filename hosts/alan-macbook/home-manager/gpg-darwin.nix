# GPG agent for alan-macbook — macOS pinentry dialog, SSH support, standard cache TTLs.
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
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    pinentry = {
      package = pkgs.pinentry_mac;
    };
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.gnupg/S.gpg-agent.ssh";
  };
}
