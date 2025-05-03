{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}: {
  home-manager = {
    users.ade-sede = import ../home-manager;
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit username homeDirectory;
    };
  };
}
