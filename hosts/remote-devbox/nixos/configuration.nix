# remote-devbox NixOS entry point — assembles system modules, injects Home Manager, and passes theme/constants.
{
  inputs,
  pkgs,
  ...
}: let
  constants = import ../constants.nix;
  inherit (constants) username allowUnfree;
  inherit (inputs) home-manager;
in {
  nixpkgs.config.allowUnfree = allowUnfree;

  imports = [
    ./hardware-config.nix
    ./networking.nix
    ./services.nix
    ../../../nixos/linux/systemd.nix
    ../../../nixos/linux/programs.nix
    ../../../nixos/common/configuration.nix
    home-manager.nixosModules.home-manager
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.users.pancho = {
    isNormalUser = true;
    description = "Pancho";
    shell = pkgs.bash;
  };

  home-manager.extraSpecialArgs =
    constants
    // {
      theme =
        ((import ../../../themes/colors.nix).${constants.theme.variant})
        // {
          variant = constants.theme.variant;
        };
    };
  home-manager.users.${username} = import ../home-manager;
  home-manager.users.pancho = import ../../../home-manager-pancho;
}
