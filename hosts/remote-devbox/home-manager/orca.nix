# Orca server for remote-devbox — CLI on PATH and an always-online orcad user unit, kept alive across boots by linger.
{
  pkgs,
  username,
  ...
}: let
  orca-ide = pkgs.callPackage ../orca-ide.nix {};
in {
  home.packages = [orca-ide];

  systemd.user.services.orca-serve = {
    Unit = {
      Description = "Orca server (orca serve --supervise)";
    };

    Service = {
      Type = "simple";
      ExecStart = "${orca-ide}/bin/orca-ide serve --port 6768 --supervise --no-pairing";
      Environment = "PATH=/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin";
      Restart = "on-failure";
      RestartSec = 10;
      KillMode = "process";
      WorkingDirectory = "%h";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
