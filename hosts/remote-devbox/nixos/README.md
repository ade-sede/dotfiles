# hosts/remote-devbox/nixos

NixOS system configuration for remote-devbox.

Covers server-specific concerns: networking (SSH, HTTP/HTTPS ports), system services (ttyd, nginx, ACME), and hardware configuration generated for a QEMU/KVM guest. The `hardware-config.nix` file is machine-generated and should not be hand-edited.
