{
  pkgs,
  lib,
  config,
  ...
}: let
  geminiKeyFile = "${config.home.secretsDir}/gemini_api_key.txt";
  claudeKeyFile = "${config.home.secretsDir}/anthropic_api_key.txt";
  openaiKeyFile = "${config.home.secretsDir}/openai_api_key.txt";

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
    secretsDir = config.home.secretsDir;
    geminiKeyFile = geminiKeyFile;
    claudeKeyFile = claudeKeyFile;
    openaiKeyFile = openaiKeyFile;
  };

  utils = {
    readFileIfExists = readFileIfExists;
  };
}
