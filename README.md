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

> **Note:** There are two sets of agent docs. `AGENTS.md` at the repo root governs how agents interact with *this repository*. Files under `dotfiles/claude/` and `dotfiles/opencode/` are application configs that get symlinked to `~/.config/` and govern how AI agents behave on the *machine itself*.

### Key Management

For generating and uploading GPG and SSH keys, see the [Key Management README](./docs/KEY_MANAGEMENT.md).

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

### Adding a New Host

1. **Create the host directory:**

   ```bash
   mkdir -p hosts/<name>/nixos hosts/<name>/home-manager
   ```

1. **Create `hosts/<name>/constants.nix`:**

   ```nix
   {
     username = "user";
     homeDirectory = "/home/user";
     fullName = "Full Name";
     userEmail = "user@example.com";
     system = "x86_64-linux";  # or "aarch64-darwin" for macOS
     allowUnfree = true;
     fishPath = "/etc/profiles/per-user/user/bin/fish";
     theme = {
       variant = "dark";  # or "light"
     };
   }
   ```

   macOS hosts omit `domain`. Server hosts may include a `domain` for TLS.

1. **Linux hosts — create `hosts/<name>/nixos/configuration.nix`:**

   - Import shared modules from `nixos/common/` and `nixos/linux/`
   - Import host-specific modules (hardware, networking, etc.)
   - Wire Home Manager via `home-manager.nixosModules.home-manager`
   - Pass `home-manager.users.${username}` pointing to `../home-manager`
   - Set `home-manager.extraSpecialArgs` with constants + theme
     See `hosts/koala-devbox/nixos/configuration.nix` or `hosts/remote-devbox/nixos/configuration.nix` as templates.

1. **Linux hosts — create `hosts/<name>/home-manager/standalone.nix`:**

   - Entry point for `home-manager switch --flake .#<name>` (standalone, outside NixOS)
   - Import nixpkgs with the host's system, pass constants + theme as `extraSpecialArgs`
   - List modules to import (common, linux, host-specific)
     See `hosts/remote-devbox/home-manager/standalone.nix` as template.

1. **Linux hosts — create `hosts/<name>/home-manager/default.nix`:**

   - Entry point when called from NixOS configuration
   - Import common, linux, and host-specific modules
   - Apply any host-specific overrides (e.g., KDE theme settings)

1. **macOS hosts — create `hosts/<name>/home-manager/default.nix`:**

   - Serves as both the NixOS-style entry point and the standalone entry
   - No `standalone.nix` needed
     See `hosts/alan-macbook/home-manager/default.nix` as template.

1. **Register in `flake.nix`:**

   - Linux hosts: add to `nixosConfigurations` and `homeConfigurations`
   - macOS hosts: add to `homeConfigurations` only

1. **Copy hardware config (Linux only):**

   ```bash
   scp root@<server-ip>:/etc/nixos/hardware-configuration.nix ./hosts/<name>/nixos/hardware-config.nix
   ```

1. **Rebuild:**

   ```bash
   home-manager switch --flake .#<name>
   ```

### Theme Switching

To switch between light and dark themes:

1. **Change the theme variant** in the `constants.nix` file for the desired host. For example, to change the theme for `remote-devbox`, edit `hosts/remote-devbox/constants.nix` and set the `theme.variant` to `"dark"` or `"light"`.

1. **Rebuild the system** using the appropriate command:

   - For NixOS: `sudo nixos-rebuild switch --flake .#<flake-name>`
   - For Home Manager: `home-manager switch --flake .#<flake-name>`
