______________________________________________________________________

## name: dotfiles-add-host description: > Scaffold a new host: create constants.nix, nixos configuration, home-manager entry points, and register in flake.nix. Interactive — guides through OS type, architecture, and scope decisions.

# Dotfiles Add Host

Use this skill when creating a new machine configuration from scratch.

## Prerequisites

Before starting, confirm with the user:

- The hostname (used for flake name and directory name)
- OS type: Linux (NixOS) or macOS (Home Manager only)
- Architecture: `x86_64-linux`, `aarch64-linux`, or `aarch64-darwin`
- Username

## Workflow

### 1. Create Directory Structure

```bash
mkdir -p hosts/<name>/nixos hosts/<name>/home-manager
```

macOS hosts skip the `nixos/` directory.

### 2. Create constants.nix

Read `README.md#adding-a-new-host` for the full schema. Create `hosts/<name>/constants.nix` with:

```nix
{
  username = "<user>";
  homeDirectory = "<path>";
  fullName = "<full name>";
  userEmail = "<email>";
  system = "<arch>";
  allowUnfree = true;
  fishPath = "<fish binary path>";
  theme = {
    variant = "dark";
  };
}
```

Ask the user about:

- `domain` — needed for TLS (servers only, omit for desktops)
- `theme.variant` — default to "dark", ask if different

### 3. Create NixOS Configuration (Linux only)

Read `hosts/koala-devbox/nixos/configuration.nix` and `hosts/remote-devbox/nixos/configuration.nix` as templates.

Ask the user:

- Is this a desktop (needs X11/Wayland, display manager, DE) or server (SSH only)?
- Does it need Flatpak, Bluetooth, or other desktop features?

Assemble the module imports based on answers:

- **Desktop**: `nixos/linux/xserver.nix`, `nixos/linux/systemd.nix`, `nixos/linux/programs.nix`, `nixos/common/configuration.nix`
- **Server**: `nixos/linux/systemd.nix`, `nixos/linux/programs.nix`, `nixos/common/configuration.nix`

Wire Home Manager the same way as the templates (see `nixos/common/configuration.nix` for the pattern).

### 4. Create Home Manager Entry Points

**Linux hosts — create both files:**

- `hosts/<name>/home-manager/standalone.nix` — use `hosts/remote-devbox/home-manager/standalone.nix` as template
- `hosts/<name>/home-manager/default.nix` — use `hosts/remote-devbox/home-manager/default.nix` as template

Import `home-manager/common/home.nix` plus `home-manager/linux/packages.nix` and `home-manager/linux/gpg.nix` for Linux hosts.

**macOS hosts — create one file:**

- `hosts/<name>/home-manager/default.nix` — use `hosts/alan-macbook/home-manager/default.nix` as template
- No `standalone.nix` needed

### 5. Register in flake.nix

Read `flake.nix` (documented in-file, see the top comment block).

- **Linux hosts**: add to both `nixosConfigurations` and `homeConfigurations`
- **macOS hosts**: add to `homeConfigurations` only

Follow the exact pattern from existing entries. The `specialArgs` must pass `inputs`.

### 6. Hardware Config (Linux, remote server)

If the server already has NixOS installed:

```bash
scp root@<server-ip>:/etc/nixos/hardware-configuration.nix ./hosts/<name>/nixos/hardware-config.nix
```

If not, note that this step comes after the initial infect deployment (see `docs/REMOTE_DEV.md` for the deploy workflow).

### 7. Verify

Run:

```bash
home-manager switch --flake .#<name> --dry-run
```

If dry-run succeeds, rebuild:

```bash
home-manager switch --flake .#<name>
```

### 8. Report

Tell the user:

- Host name and OS type
- What was created (list all files)
- Flake name for future rebuilds
- Any manual steps remaining (hardware config, SSH setup, secrets)
