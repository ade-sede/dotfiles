{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./networking.nix
    ./virtualisation.nix
    ./locals.nix
    ./services.nix
    ./audio.nix
    ./hardware.nix
    ./users.nix
    ./programs.nix
    ./nix.nix
    ./systemd.nix
    ./home-manager.nix
  ];

  system.stateVersion = "24.11";
}
