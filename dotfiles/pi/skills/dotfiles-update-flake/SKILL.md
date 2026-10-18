______________________________________________________________________

## name: dotfiles-update-flake description: > Update all flake inputs (nixpkgs, home-manager, plasma-manager, nix-flatpak), resolve conflicts, and rebuild. Handles follow chains and lock file management.

# Dotfiles Update Flake

Use this skill to update flake inputs and keep the dotfiles current.

## Workflow

### 1. Read Current Inputs

Read `flake.nix` (documented in-file, see the top comment block) to identify all inputs:

- `nixpkgs` — tracks `nixos-unstable`
- `home-manager` — follows nixpkgs
- `plasma-manager` — follows nixpkgs, home-manager follows home-manager
- `nix-flatpak` — standalone

### 2. Update Inputs

Run:

```bash
nix flake update
```

This updates all inputs to their latest committed versions and rewrites `flake.lock`.

### 3. Check for Conflicts

Read `flake.lock` and compare the new revs against the old ones. Note:

- Which inputs moved
- Whether nixpkgs moved to a new channel (e.g., `nixos-24.11` → `nixos-25.05`) — this may require module option changes

### 4. Try Building

```bash
home-manager build --flake .#koala-devbox
home-manager build --flake .#remote-devbox
home-manager build --flake .#alan-macbook
```

If any build fails, read the error. Common issues:

- **Module option changed**: nixpkgs channel bump may rename/remove options. Check the nixpkgs migration guide for the target channel.
- **Missing attribute**: a module may have been restructured. Compare with the template hosts.
- **Version incompatibility**: home-manager or plasma-manager may require a minimum nixpkgs version.

Fix the issue and retry. If you cannot resolve it, report the error and stop — do not force a broken build.

### 5. Report

Tell the user:

- Which inputs were updated (old rev → new rev)
- Whether all builds succeeded
- Any breaking changes detected
- Recommendation: rebuild now or defer
