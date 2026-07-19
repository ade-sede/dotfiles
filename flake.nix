# Flake entry point — defines all NixOS and Home Manager configuration outputs for every host.
#
# Structure:
#   nixosConfigurations: Linux hosts managed via `sudo nixos-rebuild switch --flake .#<name>`
#   homeConfigurations:   All hosts (Linux + macOS) managed via `home-manager switch --flake .#<name>`
#
# How modules compose:
#   1. constants.nix (per-host) provides username, system arch, theme variant, etc.
#   2. configuration.nix (per-host NixOS) imports shared modules from nixos/common/ and nixos/linux/,
#      wires home-manager via home-manager.nixosModules.home-manager, and passes constants+theme
#      as extraSpecialArgs.
#   3. home-manager/standalone.nix (per-host) is the entry for standalone `home-manager switch`.
#      It loads nixpkgs with the host's system, injects constants+theme as extraSpecialArgs,
#      and lists modules to import.
#   4. home-manager/default.nix (per-host) is the entry called from NixOS configuration.
#      It imports common, linux, and host-specific modules, applying any host overrides.
#   5. home-manager/common/home.nix is the universal root module imported by every host.
#
# macOS hosts (alan-macbook) have no NixOS configuration. Their home-manager/default.nix
# serves as both the NixOS-style entry point and the standalone entry (no standalone.nix).
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
