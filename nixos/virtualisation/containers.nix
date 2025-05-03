{
  config,
  pkgs,
  lib,
  homeDirectory,
  ...
}: let
  configPath = "${homeDirectory}/.dotfiles/dotfiles/litellm/config.yaml";
  configWithHome = {home = {homeDirectory = homeDirectory;};};
  homeManagerSecrets = import ../../home-manager/secrets.nix {
    inherit pkgs lib;
    config = configWithHome;
  };
  secrets = homeManagerSecrets;
  geminiKey = secrets.apiKeys.geminiKey;
  claudeKey = secrets.apiKeys.claudeKey;
  openaiKey = secrets.apiKeys.openaiKey;
in {
  virtualisation.oci-containers = {
    containers = {
      litellm-proxy = {
        image = "ghcr.io/berriai/litellm:main-latest";
        autoStart = true;
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
