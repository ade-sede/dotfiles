# Services for remote-devbox — OpenSSH, ttyd web terminal, nginx reverse proxy with ACME TLS.
{
  config,
  pkgs,
  ...
}: let
  constants = import ../constants.nix;
  colors = import ../../../themes/colors.nix;
  theme = colors.${constants.theme.variant};
  inherit (constants) userEmail domain;
in {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  users.mutableUsers = true;

  users.users.ade-sede.initialPassword = "changeme";

  environment.systemPackages = with pkgs; [
    ttyd
  ];

  systemd.services.ttyd = {
    description = "TTY over HTTP service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ttyd}/bin/ttyd -i 127.0.0.1 -p 3000 --writable -m 0 -t titleFixed=\"Terminal\" -t fontSize=20 -t fontFamily=\"InconsolataGo Nerd Font,JetBrains,SarasaMono\" -t 'theme={\"background\": \"${theme.bg}\", \"foreground\": \"${theme.fg}\"}' ${pkgs.fish}/bin/fish -c \"su ade-sede\"";
      Restart = "always";
      RestartSec = 3;
      User = "ade-sede";
      WorkingDirectory = "/home/ade-sede";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = userEmail;
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
