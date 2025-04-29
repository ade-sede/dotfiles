{ config, pkgs, lib, ... }:

let
  configPath = "/home/ade-sede/.dotfiles/dotfiles/litellm/config.yaml";
  secretsDir = "/home/ade-sede/.dotfiles/secrets";
  
  geminiKeyFile = "${secretsDir}/gemini_api_key.txt";
  claudeKeyFile = "${secretsDir}/anthropic_api_key.txt";
  openaiKeyFile = "${secretsDir}/openai_api_key.txt";
  
  readFileIfExists = file: 
    if builtins.pathExists file
    then lib.strings.removeSuffix "\n" (builtins.readFile file)
    else "";
    
  geminiKey = readFileIfExists geminiKeyFile;
  claudeKey = readFileIfExists claudeKeyFile;
  openaiKey = readFileIfExists openaiKeyFile;
in {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings = {
      "log-driver" = "local";
      "log-opts" = {
        "max-size" = "10m";
        "max-file" = "3";
      };
      "storage-driver" = "overlay2";
    };
  };

  users.users.ade-sede.extraGroups = [ "docker" ];

  networking.firewall.allowedTCPPorts = [ 4000 ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      litellm-proxy = {
        image = "ghcr.io/berriai/litellm:main-latest";
        autoStart = false;
        ports = [ "127.0.0.1:4000:4000" ];
        volumes = [
          "${configPath}:/app/config.yaml"
        ];
        environment = {
          GEMINI_API_KEY = geminiKey;
          ANTHROPIC_API_KEY = claudeKey;
          OPENAI_API_KEY = openaiKey;
        };
        cmd = [ "--config" "/app/config.yaml" ];
      };
    };
  };
}
