{
  config,
  pkgs,
  lib,
  ...
}: let
  configPath = "/home/ade-sede/.dotfiles/dotfiles/litellm/config.yaml";
  secrets = import ../secrets.nix {inherit pkgs lib;};
  geminiKey = secrets.apiKeys.geminiKey;
  claudeKey = secrets.apiKeys.claudeKey;
  openaiKey = secrets.apiKeys.openaiKey;
in {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      litellm-proxy = {
        image = "ghcr.io/berriai/litellm:main-latest";
        autoStart = false;
        ports = ["127.0.0.1:4000:4000"];
        volumes = [
          "${configPath}:/app/config.yaml"
        ];
        environment = {
          GEMINI_API_KEY = geminiKey;
          ANTHROPIC_API_KEY = claudeKey;
          OPENAI_API_KEY = openaiKey;
        };
        cmd = ["--config" "/app/config.yaml"];
      };
    };
  };
}
