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
      in
        lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit username homeDirectory secretsDir;
          };

          modules = [
            ./nixos/hardware-configs/koala-devbox.nix
            ./nixos/configuration.nix
            ./nixos/xserver.nix
            home-manager.nixosModules.home-manager
            {nixpkgs.config.allowUnfree = true;}
            {
              home-manager.sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
              ];
              home-manager.users.${username}.imports = [
                ./home-manager/plasma-config.nix
                ./home-manager/desktop.nix
                ./home-manager/linux-packages.nix
              ];
            }
          ];
        };
    };

    homeConfigurations = {
      koala-devbox = let
        username = "ade-sede";
        homeDirectory = "/home/ade-sede";
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
            inherit username homeDirectory secretsDir;
          };

          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            ./home-manager/home.nix
            ./home-manager/desktop.nix
            ./home-manager/plasma-config.nix
            ./home-manager/linux-packages.nix
          ];
        };
    };
  };
}
