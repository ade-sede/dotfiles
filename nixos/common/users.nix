# NixOS user definition — creates the ade-sede user with fish shell, wheel, and networkmanager groups.
{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.ade-sede = {
    isNormalUser = true;
    description = "Adrien DE SEDE";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };
}
