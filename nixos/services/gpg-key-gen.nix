{
  config,
  pkgs,
  lib,
  ...
}: let
  variables = import ../home-manager/variables.nix;
  userName = variables.userName;
  userEmail = variables.userEmail;
in {
  systemd.services.generate-gpg-key = {
    description = "Generate GPG key if it doesn't exist";
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
            if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys | grep -q "${userEmail}"; then
              echo "Generating GPG key for ${userEmail} (this will only happen once)"
              cat > /tmp/gpg-gen-key.batch << EOF
      %echo Generating GPG key
      Key-Type: EDDSA
      Key-Curve: ed25519
      Key-Usage: sign
      Subkey-Type: ECDH
      Subkey-Curve: cv25519
      Subkey-Usage: encrypt
      Name-Real: ${userName}
      Name-Email: ${userEmail}
      Expire-Date: 0
      %no-protection
      %commit
      %echo GPG key generation completed
      EOF
              ${pkgs.gnupg}/bin/gpg --batch --generate-key /tmp/gpg-gen-key.batch
              rm -f /tmp/gpg-gen-key.batch
            else
              echo "GPG key for ${userEmail} already exists, nothing to do"
              exit 0
            fi
    '';
  };
}
