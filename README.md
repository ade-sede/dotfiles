# Dotfiles and NixOS Configuration

This repository contains my personal dotfiles and NixOS configuration. The goal is to provide a fully reproducible system setup with the absolute minimum of manual steps required.

## Getting Started

- **NixOS:** For system-level configuration, see the [NixOS README](./nixos/README.md).
- **Home Manager:** For user-level configuration, see the [Home Manager README](./home-manager/README.md).

## Development

### Pre-commit Hooks

This repository uses pre-commit hooks to ensure code quality. To set up:

```bash
pre-commit install
```

Hooks available:

- automated format of nix files with alejandra
- automated format of markdown files with mdformat
- gitleaks for secret scanning

### Coding Agents

For coding agents, see the [AGENTS.md](./AGENTS.md) file.

### Key Management

For generating and uploading GPG and SSH keys, see the [Key Management README](./scripts/key-management/README.md).

### Remote Development

For setting up a remote development server, see the [Remote Development Guide](./docs/REMOTE_DEV.md).

### Repository Structure

```
.dotfiles/
├── flake.nix               # Main entry point
├── nixos/                  # System configuration
│   └── common/
├── home-manager/           # User configuration
│   └── common/
├── hosts/
│   ├── koala-devbox/       # Linux desktop/laptop config
│   │   ├── nixos/
│   │   └── home-manager/
│   ├── remote-devbox/      # Remote development box config
│   │   ├── nixos/
│   │   └── home-manager/
│   └── alan-macbook/       # macOS laptop config
│       └── home-manager/
├── scripts/
├── dotfiles/               # Application configs
├── secrets/
├── KDE/                    # Backup of some KDE configuration files
├── profile-images/
└── wallpapers/
```
