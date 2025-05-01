{
  config,
  pkgs,
  lib,
  ...
}: let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  };
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./bootloader.nix
    ./networking.nix
    ./virtualisation.nix
    ./locals.nix
    ./services.nix
    ./desktop.nix
    ./audio.nix
    ./hardware.nix
    ./users.nix
    ./programs.nix
    ./nix.nix
    ./systemd.nix
    ./home-manager.nix
    "${home-manager}/nixos"
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
