# Standalone Home Manager entry point for koala-devbox — wires nixpkgs, theme, and plasma-manager for `home-manager switch`.
{
  nixpkgs,
  nixpkgs-auto-update,
  plasma-manager,
}: let
  constants = import ../constants.nix;
  pkgs = import nixpkgs {
    system = constants.system;
    overlays = [(import ../../../overlays/rolling.nix nixpkgs-auto-update)];
    config = {
      allowUnfree = constants.allowUnfree;
    };
  };
in {
  inherit pkgs;
  extraSpecialArgs =
    constants
    // {
      theme =
        ((import ../../../themes/colors.nix).${constants.theme.variant})
        // {
          variant = constants.theme.variant;
        };
    };
  modules = [
    plasma-manager.homeManagerModules.plasma-manager
    ./default.nix
  ];
}
