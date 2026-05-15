# hosts

Per-machine entry points and constants.

Each subdirectory represents one machine and contains a `constants.nix` with machine-specific values (username, home directory, system architecture, active theme variant) and a `home-manager/` subtree with the Home Manager configuration for that machine. Linux machines additionally have a `nixos/` subtree for NixOS system-level configuration.
