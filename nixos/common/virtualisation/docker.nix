{
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings = {
      "log-driver" = "local";
      "log-opts" = {
        "max-size" = "10m";
        "max-file" = "3";
      };
      "storage-driver" = "overlay2";
    };
  };

  users.users.ade-sede.extraGroups = ["docker"];
}
