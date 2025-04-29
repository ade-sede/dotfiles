# Dotfiles and NixOS Configuration

This repository contains my personal dotfiles and NixOS configuration. The goal is to provide a fully reproducible system setup with the absolute minimum of manual steps required.

## NixOS Configuration Structure

- `nixos/configuration.nix`: Main NixOS system configuration
- `nixos/home-manager/`: Home Manager configuration files
  - `home.nix`: Main Home Manager configuration
  - `packages.nix`: User packages
  - `dotfiles.nix`: Symlinks to dotfiles in the repository
  - `programs.nix`: Program-specific configurations
  - `variables.nix`: User identity variables used across configurations
  - `scripts/`: Scripts used by home-manager configurations

## Repository Structure

- `/nixos/`: NixOS and Home Manager configurations
- `/scripts/`: Utility scripts
- `/dotfiles/`: Application-specific configuration files
  - `fish/`: Fish shell configuration
  - `git/`: Git configuration
  - `nvim/`: Neovim configuration
  - `ghostty/`: Ghostty terminal configuration
  - `sway/`: Sway window manager configuration
  - `waybar/`: Waybar configuration
  - `tmux/`: Tmux configuration
  - `dunst/`: Dunst notification daemon configuration
  - `emacs/`: Emacs configuration
  - `kanshi/`: Kanshi output management configuration
  - `swaylock/`: Swaylock screen locking configuration
  - `starship.toml`: Starship prompt configuration
- `/Wallpaper/`: Wallpaper images

## Setup

1. Replace the global NixOS configuration with a reference to this repository:
   
   Replace all content in `/etc/nixos/configuration.nix` with:
   ```nix
   { config, pkgs, ... }:

   {
     imports =
       [
         /home/ade-sede/.dotfiles/nixos/configuration.nix
       ];
   }
   ```
   This approach keeps the entire NixOS configuration within the dotfiles repository, not in /etc/.

2. Apply configuration:
   ```
   sudo nixos-rebuild switch
   ```

3. To update just home-manager configuration:
   ```
   home-manager switch
   ```

## Add New Dotfiles

To add a new dotfile to be managed by Home Manager:

1. Add the configuration file to your dotfiles repository
2. Add a symlink entry in `home-manager/dotfiles.nix`
3. Apply changes with `home-manager switch`

## Managing NixOS Generations

### Listing Generations

List all available system generations:
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Deleting Old Generations

Remove old system generations to free up disk space:

```bash
# Delete all generations older than 14 days
sudo nix-collect-garbage --delete-older-than 14d

# Delete specific generations
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system 123 124 125

# Delete all generations except the current one
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system old
```

### Updating Boot Menu

After deleting old generations, update the boot menu to remove entries for deleted generations:

```bash
# Update GRUB bootloader configuration
sudo nixos-rebuild boot
```

This removes old entries from the boot menu and reclaims disk space used by old system configurations.

## Setting Up GitHub Access

After setting up a new machine, upload your SSH and GPG keys to GitHub:

### Upload SSH Key to GitHub

```fish
# Add the SSH key to GitHub using GitHub CLI
gh auth login  # First authenticate with GitHub if needed
gh ssh-key add ~/.ssh/id_ed25519.pub -t "koala-devbox" # Should be pushe automatically if it exists when login-in for the first time
```

### Upload GPG Key to GitHub

```fish
# List your GPG keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Export your GPG public key to a file
gpg --armor --export KEY_ID > gpg_github_key.asc

# Add the key to GitHub using GitHub CLI
gh gpg-key add gpg_github_key.asc

# Clean up
rm gpg_github_key.asc
```

After adding these keys, you'll be able to interact with GitHub repositories securely.
