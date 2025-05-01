{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    users.ade-sede = import ../home-manager;
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
