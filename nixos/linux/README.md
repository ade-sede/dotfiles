# nixos/linux

NixOS system configuration shared across Linux hosts, applied below `nixos/common/`.

Covers Linux-specific concerns: systemd tuning, nix-ld for running unpatched binaries, fish shell system-wide enablement, and the display server / desktop environment stack (SDDM, KDE Plasma 6). The display server module is only imported by hosts that have a desktop.
