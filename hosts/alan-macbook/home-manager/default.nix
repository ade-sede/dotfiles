{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../../home-manager/common/home.nix
    ./gpg-darwin.nix
    ./alan-bin.nix
  ];
}
