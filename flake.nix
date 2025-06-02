{
  description = "NixOS and Home Manager Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      koala-devbox = nixpkgs.lib.nixosSystem {
        system = (import ./hosts/koala-devbox/constants.nix).system;
        specialArgs = {inputs = inputs;};
        modules = [
          ./hosts/koala-devbox/nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      koala-devbox =
        home-manager.lib.homeManagerConfiguration
        (import ./hosts/koala-devbox/home-manager/standalone.nix {inherit nixpkgs plasma-manager;});

      alan-macbook =
        home-manager.lib.homeManagerConfiguration
        (import ./hosts/alan-macbook/home-manager/default.nix nixpkgs);
    };
  };
}
