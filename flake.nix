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
    username = "ade-sede";
    homeDirectory = "/home/${username}";
  in {
    nixosConfigurations = {
      koala-devbox = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit username homeDirectory;
        };
        modules = [
          ./nixos/hardware-configs/koala-devbox.nix
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      development-server = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit username homeDirectory;
        };
	# Make sure to exclude xserver and desktop related
        modules = [
          # Add hardware config
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
        extraSpecialArgs = {
          inherit username;
          homeDirectory = "/Users/${username}";
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
