{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../../home-manager/common/home.nix
    ./plasma-config.nix
    ./desktop-linux.nix
    ./packages-linux.nix
    ./gpg-linux.nix
  ];
}
