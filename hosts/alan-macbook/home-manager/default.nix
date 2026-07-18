# alan-macbook Home Manager entry point — also serves as the standalone entry; wires common, macOS GPG, and alan-bin.
nixpkgs: let
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
    ../../../home-manager/common/home.nix
    ./gpg-darwin.nix
    ./alan-bin.nix
    ./packages.nix
  ];
}
