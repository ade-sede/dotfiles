# Shared NixOS root — imported by every NixOS host; wires common system modules and sets stateVersion.
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
