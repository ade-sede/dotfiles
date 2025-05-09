# Dotfiles and NixOS Configuration

This repository contains my personal dotfiles and NixOS configuration. The goal is to provide a fully reproducible system setup with the absolute minimum of manual steps required.

Still experimenting, it's rough around the edges and a bit broken in some places...

## Getting Started

### Prerequisites

- Must be a NixOS machine or at the very least a system with Nix package manager installed

#### For all systems - Enable flakes

```bash
# For NixOS
sudo mkdir -p /etc/nixos/
echo "{ nix.settings.experimental-features = [ 'nix-command' 'flakes' ]; }" | sudo tee /etc/nixos/flakes.nix


# For non-NixOs machines
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

#### For NixOs - Install home-manager via nix channels

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

#### For NixOs - Remove legacy config (optional)

When using flakes the entirety of the system is stored in `/var/nix/*`.
You can safely remove your config at `/etc/nixos/configuration.nix`.
Copy the hardware config to `hardware-configs` directory
You must keep the `flakes.nix`

### Installation

Each flake is supposed to re-present a concrete machine: my personal laptop, my steam deck, my work laptop...
Run `home-manager` or `nixos-rebuild` specifying the corresponding build.

```bash
# Clone the repository
git clone https://github.com/ade-sede/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# For example, on personal laptop
# To re-build the system (if the system is a NixOS machine)
sudo nixos-rebuild switch --flake .#koala-devbox

# To re-build user level configuration & packages handled by home manager
home-manager switch --flake .#koala-devbox
```

Available NixOs flakes:
- `koala-devbox` for a desktop or laptop setup

Available Home Manager flakes:
- `koala-devbox` 
- `macbook`

### Uploading security keys to GitHub

GPG & SSH keys can be generated using scripts in the `scripts/key-management` directory:
```bash
# Generate SSH key
~/scripts/key-management/generate-ssh-key.sh

# Generate GPG key
~/scripts/key-management/generate-gpg-key.sh
```

These scripts use the environment variables `FULL_NAME` and `EMAIL` which are set automatically by home-manager.
The keys are not automatically uploaded to GitHub.

```fish
# List GPG keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Export GPG public key to a file
gpg --armor --export <KEY_ID> > gpg_github_key.asc

# Add the key to GitHub using GitHub CLI
gh gpg-key add gpg_github_key.asc

# Clean up
rm gpg_github_key.asc

# Add the SSH key to GitHub using GitHub CLI
gh auth login  # First authenticate with GitHub if needed
gh ssh-key add ~/.ssh/id_ed25519.pub -t "koala-devbox" # Should be pushed automatically if it exists when logging in for the first time
```

## Managing packages & configurations

### Installing new packages

Define the packages directly in configuration files:

- `home-manager/packages.nix` for user level packages
- `nixos/desktop.nix` for system level packages (preferred for GUI applications)

If you installed changes in `nixos/desktop.nix` you will need to rebuild the flake following the instructions at the top of the README.
If you made a change in `home-manager/packages.nix` you can re-apply the home-manager config

```bash
home-manager switch
```

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
2. Add a symlink entry in `home-manager/dotfiles.nix`
3. Apply changes with `home-manager switch`

### Backing up plasma configuration

This experiment failed, not currently able to manage plasma through _plasma-manager_.
It worked for window rules and desktop but was unstable for shortcuts, often crashing.
Store and manually import configurations in `dotfiles/KDE`.

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

After deleting old generations, update the boot menu to remove entries for deleted generations:

```bash
sudo nixos-rebuild boot --flake .#<flake name>
```

This removes old entries from the boot menu and reclaims disk space used by old system configurations.

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
├── flake.nix               # Main entry point
├── nixos/                  # System configuration
│   └── common/             # Common NixOS modules
├── home-manager/           # User configuration
│   └── common/             # Common home-manager modules
├── hosts/                  # Host-specific configurations
│   ├── koala-devbox/       # Linux desktop/laptop config
│   │   ├── nixos/          # Host-specific NixOS modules
│   │   └── home-manager/   # Host-specific home-manager modules
│   └── macbook/            # macOS laptop config
│       └── home-manager/   # Host-specific home-manager modules
├── scripts/                # Utility scripts
├── dotfiles/               # Application configs
├── secrets/                # Secret files
├── KDE/                    # KDE Plasma configurations
├── profile-images/         # Profile pictures
└── wallpapers/             # Desktop wallpapers
```

### NixOS Configuration Structure

```
nixos/common/              # Common NixOS modules shared across all systems
├── configuration.nix      # Main NixOS entry point
├── bootloader.nix
├── hardware.nix
├── networking.nix
├── audio.nix
├── programs.nix
├── services.nix
├── users.nix
├── home-manager.nix       # Home-manager integration
├── locals.nix
├── nix.nix
├── systemd.nix
├── virtualisation.nix
└── virtualisation/
    └── docker.nix

home-manager/common/       # Common home-manager modules shared across all systems
├── home.nix               # Main home-manager entry point
├── packages.nix
├── dotfiles.nix           # Symlinks to dotfiles in the repository
├── programs.nix
├── variables.nix
├── services.nix
├── fish.nix
├── git.nix
├── tmux.nix
└── meme.nix

hosts/koala-devbox/        # Linux-specific host configuration
├── nixos/
│   ├── configuration.nix  # Host-specific NixOS config
│   ├── hardware-config.nix
│   └── xserver.nix
└── home-manager/
    ├── default.nix        # Host-specific home-manager config
    ├── plasma-config.nix
    ├── desktop-linux.nix
    ├── packages-linux.nix
    └── gpg-linux.nix

hosts/macbook/             # macOS-specific host configuration
└── home-manager/
    ├── default.nix        # Host-specific home-manager config
    └── gpg-darwin.nix
```

### Importing plasma config

```bash
# Automatically dump config
nix run github:nix-community/plasma-manager > home-manager/plasma-config.nix
```

For some reason _shortcuts_ don't work ...
Remove the `shortcut` object manually before commiting the file and use the backup shortcuts in `KDE/` instead. 
They can be imported in the system settings UI.
