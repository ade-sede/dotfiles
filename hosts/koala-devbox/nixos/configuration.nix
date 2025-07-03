{inputs, ...}: let
  constants = import ../constants.nix;
  inherit (constants) username allowUnfree;
  inherit (inputs) home-manager plasma-manager;
in {
  nixpkgs.config.allowUnfree = allowUnfree;

  imports = [
    ./hardware-config.nix
    ./networking.nix
    ./audio.nix
    ./bootloader.nix
    ./hardware.nix
    ./flatpak.nix
    ../../../nixos/linux/xserver.nix
    ../../../nixos/linux/systemd.nix
    ../../../nixos/linux/programs.nix
    ../../../nixos/common/configuration.nix
    home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

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

  home-manager.sharedModules = [
    plasma-manager.homeManagerModules.plasma-manager
  ];
}
