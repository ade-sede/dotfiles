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
  extraSpecialArgs = constants;
  modules = [
    ./default.nix
  ];
}
