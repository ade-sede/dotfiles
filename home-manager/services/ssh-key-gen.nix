{
  config,
  pkgs,
  lib,
  ...
}: let
  variables = import ../variables.nix;
  userEmail = variables.userEmail;
in {
  home.activation.generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f $HOME/.ssh/id_ed25519 ]; then
      echo "Generating SSH key (this will only happen once)"
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N "" -C "${userEmail}"
    else
      echo "SSH key already exists, nothing to do"
    fi
  '';
}