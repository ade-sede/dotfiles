{
  nixpkgs,
  plasma-manager,
}: let
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
    plasma-manager.homeManagerModules.plasma-manager
    ./default.nix
  ];
}
