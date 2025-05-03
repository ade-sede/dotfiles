{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      cores = 0;
      fsync-metadata = false;
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000;
      max-free = 1000000000;
    };

    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 7;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    nrBuildUsers = 32;
  };
}
