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
