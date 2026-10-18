# remote-devbox Home Manager entry point — assembles common and Linux modules with remote GPG config.
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
