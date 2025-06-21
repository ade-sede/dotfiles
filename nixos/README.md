# NixOS Configuration

This directory contains the NixOS configuration for the systems managed by this repository.

## Getting Started

### Prerequisites

- Must be a NixOS machine.

#### Enable flakes

```bash
# For NixOS
sudo mkdir -p /etc/nixos/
echo "{ nix.settings.experimental-features = [ 'nix-command' 'flakes' ]; }" | sudo tee /etc/nixos/flakes.nix
```

#### Install home-manager via nix channels

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

#### Remove legacy config (optional)

When using flakes the entirety of the system is stored in `/var/nix/*`.
You can safely remove your config at `/etc/nixos/configuration.nix`.
Copy the hardware config to `hardware-configs` directory
You must keep the `flakes.nix`

### Installation

To re-build the system (if the system is a NixOS machine)

```bash
sudo nixos-rebuild switch --flake .#<flake-name>
```

Available NixOs flakes:

- `koala-devbox` for a desktop or laptop setup

## Managing NixOS Generations and Storage Space

### Listing Generations

List all available system generations:

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Cleaning Up Nix Store

When your Nix setup is taking too much space, you have several options to free up storage:

#### Quick Garbage Collection

The fastest way to reclaim space:

```bash
# Remove all generations except the current one, with -d flag to delete old generations
sudo nix-collect-garbage -d
```

#### Optimize the Nix Store

After garbage collection, optimize the store to save additional space:

```bash
sudo nix-store --optimize
```

This command deduplicates identical files in the Nix store using hard links.

#### Deleting Old Generations

Remove old system generations to free up disk space:

```bash
# Delete generations older than a specific timeframe
sudo nix-collect-garbage --delete-older-than 14d

# Delete specific generations
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system 123 124 125

# Delete all generations except the current one
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system old
```

### Updating Boot Menu After Cleanup

After deleting old generations, update the boot menu to remove entries for deleted generations:

```bash
sudo nixos-rebuild boot --flake .#<flake name>
```

This removes old entries from the boot menu and finalizes the reclamation of disk space used by old system configurations.
