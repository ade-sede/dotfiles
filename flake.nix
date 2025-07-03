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
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    nix-flatpak,
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
      remote-devbox = nixpkgs.lib.nixosSystem {
        system = (import ./hosts/remote-devbox/constants.nix).system;
        specialArgs = {inputs = inputs;};
        modules = [
          ./hosts/remote-devbox/nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      koala-devbox =
        home-manager.lib.homeManagerConfiguration
        (import ./hosts/koala-devbox/home-manager/standalone.nix {inherit nixpkgs plasma-manager;});

      remote-devbox =
        home-manager.lib.homeManagerConfiguration
        (import ./hosts/remote-devbox/home-manager/standalone.nix {inherit nixpkgs;});

      alan-macbook =
        home-manager.lib.homeManagerConfiguration
        (import ./hosts/alan-macbook/home-manager/default.nix nixpkgs);
    };
  };
}
