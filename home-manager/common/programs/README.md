# home-manager/common/programs

Per-program Home Manager modules applied to every host.

Each file configures one program. Modules that apply theming receive the `theme` specialArg and read color values from it directly. All files in this directory are imported by `home-manager/common/home.nix`.
