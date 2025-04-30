{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    users.ade-sede = import ./home-manager/home.nix;
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}