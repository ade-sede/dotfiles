# Standalone Home Manager entry point for pancho — wires nixpkgs for `home-manager switch --flake .#pancho`.
{nixpkgs}: let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
  };
in {
  inherit pkgs;
  modules = [
    ./default.nix
  ];
}
