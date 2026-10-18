# Shared Home Manager services — daily Nix garbage collection for the user profile (Linux hosts only).
{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    systemd.user = {
      services.nix-gc = {
        Unit.Description = "Nix user profile garbage collection";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 15d";
        };
      };

      timers.nix-gc = {
        Unit.Description = "Nix user profile garbage collection";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
