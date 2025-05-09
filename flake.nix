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
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      koala-devbox = let
        username = "ade-sede";
        homeDirectory = "/home/ade-sede";
        fullName = "Adrien DE SEDE";
        userEmail = "adrien.de.sede@gmail.com";
      in
        lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit username homeDirectory fullName userEmail;
          };

          modules = [
            ./hosts/koala-devbox/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {nixpkgs.config.allowUnfree = true;}
            {
              home-manager.sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
              ];
            }
          ];
        };
    };

    homeConfigurations = {
      koala-devbox = let
        username = "ade-sede";
        homeDirectory = "/home/ade-sede";
        fullName = "Adrien DE SEDE";
        userEmail = "adrien.de.sede@gmail.com";
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit username homeDirectory fullName userEmail;
          };

          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            ./hosts/koala-devbox/home-manager/default.nix
          ];
        };

      macbook = let
        username = "ade-sede";
        homeDirectory = "/Users/ade-sede";
        fullName = "Adrien DE SEDE";
        userEmail = "adrien.de-sede@alan.eu";
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
          };
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit username homeDirectory fullName userEmail;
          };

          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            ./hosts/macbook/home-manager/default.nix
          ];
        };
    };
  };
}