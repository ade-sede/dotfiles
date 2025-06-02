{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../../home-manager/common/home.nix
    ../../../home-manager/linux/packages.nix
    ../../../home-manager/linux/gpg.nix
  ];
}
