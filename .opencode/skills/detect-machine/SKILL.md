______________________________________________________________________

## name: detect-machine description: Use when the current machine, hostname, or flake target needs to be identified before running a Nix or Home Manager operation. Runs hostname, maps the result to one of the three known flake names, and confirms with the user before returning the flake name for use in subsequent steps.

# Detect Machine

## Known machines

| Hostname | Flake name | OS | Notes |
|-----------------|-----------------|----------------|---------------------------|
| `koala-devbox` | `koala-devbox` | NixOS (x86_64) | Linux desktop, KDE Plasma |
| `remote-devbox` | `remote-devbox` | NixOS (x86_64) | Linux server, no desktop |
| `alan-macbook` | `alan-macbook` | macOS (aarch64)| Darwin, no NixOS |

## Workflow

1. Run `hostname` to get the current machine name.
1. Match the output against the known hostnames above.
1. If the hostname matches exactly, use the corresponding flake name.
1. If the hostname is unrecognized, ask the user to pick from the three known flake names.
1. Ask the user to confirm the detected machine before proceeding.
1. Return the confirmed flake name to the calling context.
