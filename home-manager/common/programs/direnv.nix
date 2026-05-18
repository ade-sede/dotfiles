# direnv config — enables direnv with nix-direnv integration for per-directory environment loading.
{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
