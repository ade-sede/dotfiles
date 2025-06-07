{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./virtualisation.nix
    ./locals.nix
    ./services.nix
    ./users.nix
    ./nix.nix
    ./home-manager.nix
  ];

  system.stateVersion = "24.11";
}
