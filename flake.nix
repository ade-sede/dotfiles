{
  description = "NixOS and Home Manager Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      desktop = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          /etc/nixos/hardware-configuration.nix # Each machine is responsible for storing its hardware configuration locally
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      development-server = lib.nixosSystem {
        system = "x86_64-linux";
	# Make sure to exclude xserver and desktop related
        modules = [
          /etc/nixos/hardware-configuration.nix # Each machine is responsible for storing its hardware configuration locally
          ./nixos/configuration.nix
          {
            imports = lib.mkForce (
              lib.filter
              (path: baseNameOf path != "xserver.nix")
              (import ./nixos/configuration.nix).imports
            );

            home-manager.users.ade-sede.imports = lib.mkForce (
              lib.filter
              (path: baseNameOf path != "desktop.nix")
              (import ./home-manager/home.nix).imports
            );
          }
          home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      "ade-sede@home-manager-only" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
