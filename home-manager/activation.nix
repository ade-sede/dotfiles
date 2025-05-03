{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./activation/gpg-key-gen.nix
    ./activation/ssh-key-gen.nix
  ];
}
