# NixOS Home Manager integration — shared HM module options (useGlobalPkgs, useUserPackages, extraSpecialArgs).
{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  fullName,
  userEmail,
  ...
}: {
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit username homeDirectory fullName userEmail;
    };
  };
}
