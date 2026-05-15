# Standalone Home Manager entry point for remote-devbox — wires nixpkgs and theme for `home-manager switch`.
{nixpkgs}: let
  constants = import ../constants.nix;
  pkgs = import nixpkgs {
    system = constants.system;
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
    ./default.nix
  ];
}
