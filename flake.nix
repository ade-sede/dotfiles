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
      koala-devbox = let
        username = "ade-sede";
        homeDirectory = "/home/ade-sede";
      in
        lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit username homeDirectory;
          };

          modules = [
            ./nixos/hardware-configs/koala-devbox.nix
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            { nixpkgs.config.allowUnfree = true; }
          ];
        };

      development-server = let
        username = "ade-sede";
        homeDirectory = "/home/ade-sede";
      in
        lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit username homeDirectory;
          };

          # Make sure to exclude xserver and desktop related
          modules = [
            # TODO Add hardware config
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
              
              nixpkgs.config.allowUnfree = true;
            }
            home-manager.nixosModules.home-manager
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
            inherit username homeDirectory;
          };
    
          modules = [
            ./home-manager/home.nix
          ];
        };
    };
  };
}
