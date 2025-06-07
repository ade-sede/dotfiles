{inputs, ...}: let
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

  home-manager.extraSpecialArgs = constants;
  home-manager.users.${username} = import ../home-manager;
}
