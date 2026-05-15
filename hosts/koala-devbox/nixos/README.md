# hosts/koala-devbox/nixos

NixOS system configuration for koala-devbox.

Covers machine-specific concerns: hardware (Bluetooth, audio via PipeWire), bootloader (systemd-boot with Plymouth splash), networking (firewall for Steam Remote Play), XDG portals, and Flatpak. The `hardware-config.nix` file is machine-generated and should not be hand-edited.
