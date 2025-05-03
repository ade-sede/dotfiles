{
  pkgs,
  lib,
  config,
  ...
}: let
  secretsDir = "${config.home.homeDirectory}/.dotfiles/secrets";

  geminiKeyFile = "${secretsDir}/gemini_api_key.txt";
  claudeKeyFile = "${secretsDir}/anthropic_api_key.txt";
  openaiKeyFile = "${secretsDir}/openai_api_key.txt";

  readFileIfExists = file:
    if builtins.pathExists file
    then lib.strings.removeSuffix "\n" (builtins.readFile file)
    else "";
in {
  apiKeys = {
    geminiKey = readFileIfExists geminiKeyFile;
    claudeKey = readFileIfExists claudeKeyFile;
    openaiKey = readFileIfExists openaiKeyFile;
  };

  paths = {
    secretsDir = secretsDir;
    geminiKeyFile = geminiKeyFile;
    claudeKeyFile = claudeKeyFile;
    openaiKeyFile = openaiKeyFile;
  };

  utils = {
    readFileIfExists = readFileIfExists;
  };
}
