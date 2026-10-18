# alan-macbook Home Manager entry point — also serves as the standalone entry; wires common, macOS GPG, and alan-bin.
{
  nixpkgs,
  nixpkgs-auto-update,
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
    ../../../home-manager/common/home.nix
    ./gpg-darwin.nix
    ./alan-bin.nix
    ./packages.nix
  ];
}
