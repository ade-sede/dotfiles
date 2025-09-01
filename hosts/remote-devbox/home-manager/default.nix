{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../../home-manager/common/home.nix
    ../../../home-manager/linux/packages.nix
    ./gpg-remote.nix
  ];
}
