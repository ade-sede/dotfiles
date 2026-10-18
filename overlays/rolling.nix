# Overrides agent CLIs with versions from the nixpkgs-auto-update input, so they roll independently of the main pin.
nixpkgsAutoUpdate: final: prev: let
  rolling = import nixpkgsAutoUpdate {
    system = prev.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  inherit (rolling) claude-code opencode pi-coding-agent;
}
