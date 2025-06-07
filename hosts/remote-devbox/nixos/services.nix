{
  config,
  pkgs,
  lib,
  ...
}: let
  ttyd-nerd = pkgs.stdenv.mkDerivation rec {
    pname = "ttyd-nerd";
    version = "1.7.7";

    src = pkgs.fetchFromGitHub {
      owner = "2moe";
      repo = "ttyd-nerd";
      rev = "nerd-font";
      hash = "sha256-eA7AJNdmli66R2On4KwQ3dR41ceVDmuzASYzgP22/GY=";
    };

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      openssl
      libwebsockets
      json_c
      libuv
      zlib
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    meta = with lib; {
      description = "Share your terminal over the web with nerd font support";
      homepage = "https://github.com/2moe/ttyd-nerd";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  users.mutableUsers = true;

  users.users.ade-sede.initialPassword = "changeme";

  environment.systemPackages = with pkgs; [
    ttyd-nerd
  ];

  systemd.services.ttyd = {
    description = "TTY over HTTP service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${ttyd-nerd}/bin/ttyd -i 0.0.0.0 -p 3000 --writable -m 0 -t titleFixed=\"Terminal\" -t fontSize=20 -t fontFamily=\"InconsolataGo Nerd Font,JetBrains,SarasaMono\" -t 'theme={\"background\": \"white\", \"foreground\": \"black\"}' ${pkgs.fish}/bin/fish -c \"su ade-sede\"";
      Restart = "always";
      RestartSec = 3;
      User = "ade-sede";
      WorkingDirectory = "/home/ade-sede";
    };
  };
}
