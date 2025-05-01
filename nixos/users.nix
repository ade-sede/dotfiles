{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.ade-sede = {
    isNormalUser = true;
    description = "Adrien";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };
}
