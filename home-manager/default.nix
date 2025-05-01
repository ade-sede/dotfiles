{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ./services.nix
  ];
}