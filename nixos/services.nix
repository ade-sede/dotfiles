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

  services.printing.enable = false;
  
  systemd.services.generate-gpg-key.enable = true;
  systemd.services.generate-ssh-key.enable = true;
}