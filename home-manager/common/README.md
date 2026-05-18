# home-manager/common

Shared Home Manager configuration applied to every host regardless of OS.

Contains the universal root module (`home.nix`), common packages, dotfile symlinks, and all per-program modules. Everything here runs on Linux and macOS alike. OS-specific or host-specific concerns belong in `home-manager/linux/` or the relevant `hosts/<name>/home-manager/` directory.
