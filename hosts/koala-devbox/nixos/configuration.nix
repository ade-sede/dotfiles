{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  fullName,
  userEmail,
  ...
}: {
  imports = [
    ./hardware-config.nix
    ./xserver.nix
    ../../../nixos/common/configuration.nix
  ];

  home-manager.users.${username} = import ../home-manager;
}