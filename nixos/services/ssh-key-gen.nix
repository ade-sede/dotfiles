{
  config,
  pkgs,
  lib,
  ...
}: let
  variables = import ../home-manager/variables.nix;
  userEmail = variables.userEmail;
in {
  systemd.services.generate-ssh-key = {
    description = "Generate SSH key if it doesn't exist";
    wantedBy = ["default.target"];
    partOf = ["graphical-session.target"];
    after = ["network.target"];

    startLimitIntervalSec = 0;
    serviceConfig = {
      Type = "oneshot";
      User = "ade-sede";
      RemainAfterExit = true;
    };

    script = ''
      if [ ! -f /home/ade-sede/.ssh/id_ed25519 ]; then
        echo "Generating SSH key (this will only happen once)"
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f /home/ade-sede/.ssh/id_ed25519 -N "" -C "${userEmail}"
      else
        echo "SSH key already exists, nothing to do"
        exit 0
      fi
    '';
  };
}
