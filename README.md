# Dotfiles and NixOS Configuration

This repository contains my personal dotfiles and NixOS configuration. The goal is to provide a fully reproducible system setup with the absolute minimum of manual steps required.

## Setup

### 1. Replace the global NixOS configuration with a reference to this repository:

Replace all content in `/etc/nixos/configuration.nix` with:

```nix
{
config,
pkgs,
...
}: {
imports = [
 /home/ade-sede/.dotfiles/nixos/configuration.nix
];
}
```

This approach keeps the entire NixOS configuration within the dotfiles repository, not in /etc/.

### 2. Apply configuration:

```
sudo nixos-rebuild switch
```

### 3. Uploading security keys to GitHub

GPG & SSH keys are supposed to be generated automatically by this config to get started fast.
But they are not automatically uploaded to GitHub.

```fish
# List GPG keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Export GPG public key to a file
gpg --armor --export <KEY_ID> > gpg_github_key.asc

# Add the key to GitHub using GitHub CLI
gh gpg-key add gpg_github_key.asc

# Clean up
rm gpg_github_key.asc
```

## Managing packages

Define the packages directly in nix:

- `nixos/home-manager/packages.nix` for user level packages
- `nixos/desktop.nix` for system level packages (preferred for GUI applications)

### Adding a NPM package through nix

```nix
{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "claude" ''
      exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
    '')
  ];
}
```

This defines `claude` as a shell script that invokes `npx @anthropic-ai/claude-code`.

### Adding a Python package through nix

```nix
{
  home.packages = with pkgs; [
    python311Packages.requests
    python311Packages.numpy
    pythonPackages.pandas
  ];
}
```

### Adding additional configuration for all your software

You can either:

- add a new configuration file under `dotfiles/`
- inline the configuration in nix
- use nix specific configuration options, if the software is supported (example: fish)

Adding a new configuration file as a dotfile is recommended way.

### Adding a dotfile

To add a new dotfile to be managed by Home Manager:

1. Add the configuration file in `dotfiles/<software-name>`
1. Add a symlink entry in `nixos/home-manager/dotfiles.nix`
1. Apply changes with `home-manager switch`

## Managing NixOS Generations

### Listing Generations

List all available system generations:

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Deleting Old Generations

Remove old system generations to free up disk space:

```bash
# Self explanatory
sudo nix-collect-garbage --delete-older-than 14d

# Delete specific generations
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system 123 124 125

# Delete all generations except the current one
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system old
```

### Updating Boot Menu

After deleting old generations, it is possible to update the boot menu to remove entries for deleted generations:

```bash
sudo nixos-rebuild boot
```

This removes old entries from the boot menu and reclaims disk space used by old system configurations.

## Setting Up GitHub Access

After setting up a new machine, upload SSH and GPG keys to GitHub:

### Upload SSH Key to GitHub

```fish
# Add the SSH key to GitHub using GitHub CLI
gh auth login  # First authenticate with GitHub if needed
gh ssh-key add ~/.ssh/id_ed25519.pub -t "koala-devbox" # Should be pushed automatically if it exists when logging in for the first time
```

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

### Repository Structure

```
.dotfiles/
├── nixos/           # NixOS configuration
├── scripts/         # Utility scripts
├── secrets/         # Secret files
├── dotfiles/        # Application-specific configurations
└── Wallpaper/       # Wallpaper images
```

### NixOS Configuration Structure

```
nixos/
├── configuration.nix    # NixOS entry point
├── bootloader.nix
├── hardware.nix
├── desktop.nix
├── networking.nix
├── audio.nix
├── programs.nix
├── services.nix
├── users.nix
├── home-manager.nix
├── secrets.nix
├── virtualisation/
│   ├── containers.nix
│   └── docker.nix
├── services/
│   ├── gpg-key-gen.nix  # Ensure a GPG key is always available
│   └── ssh-key-gen.nix  # Ensure an SSH key is always available
└── home-manager/
    ├── home.nix
    ├── packages.nix
    ├── dotfiles.nix     # Symlinks to dotfiles in the repository
    ├── programs.nix
    ├── variables.nix
    ├── browsers.nix
    ├── fish.nix
    ├── git.nix
    └── tmux.nix
```
