{
  lib,
  config,
  pkgs,
  secretsDir,
  ...
}: {
  options.home = {
    secretsDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory containing secret files";
      default = secretsDir;
    };
  };
}