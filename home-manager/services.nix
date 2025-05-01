{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./services/gpg-key-gen.nix
    ./services/ssh-key-gen.nix
  ];
}
