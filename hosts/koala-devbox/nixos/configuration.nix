{inputs, ...}: let
  constants = import ../constants.nix;
  inherit (constants) username allowUnfree;
  inherit (inputs) home-manager plasma-manager;
in {
  nixpkgs.config.allowUnfree = allowUnfree;

  imports = [
    ./hardware-config.nix
    ./xserver.nix
    ../../../nixos/common/configuration.nix
    home-manager.nixosModules.home-manager
  ];

  home-manager.extraSpecialArgs = constants;
  home-manager.users.${username} = import ../home-manager;

  home-manager.sharedModules = [
    plasma-manager.homeManagerModules.plasma-manager
  ];
}
