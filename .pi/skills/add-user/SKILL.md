______________________________________________________________________

## name: add-user description: > Add a new independent user to a NixOS host with their own self-contained Home Manager config. Creates the NixOS user, a dedicated home-manager-<user>/ directory, registers a flake output, and documents how the new user manages their own config.

# Add User

Use this skill when adding a new independent user to a machine.

A new user gets a fully self-contained Home Manager configuration under `home-manager-<user>/` that shares nothing with existing users' configs — no imports from `home-manager/common/` or `home-manager/linux/`.

## Prerequisites

Before starting, confirm with the user:

- The username
- The full name
- Which host the user should be added to (must be a NixOS host)
- Which shell (bash, fish, zsh)

## Workflow

### 1. Create the Home Manager directory

```bash
mkdir -p home-manager-<user>
```

Create `home-manager-<user>/default.nix` — a self-contained module that:

- Hardcodes `home.username`, `home.homeDirectory`, `home.stateVersion`
- Enables `programs.home-manager.enable`
- Enables the chosen shell (e.g., `programs.bash.enable = true`)
- Lists packages in `home.packages`
- Uses `...` in its parameter list to absorb (and ignore) any `extraSpecialArgs` broadcast by NixOS

Template: `home-manager-pancho/default.nix`

Create `home-manager-<user>/standalone.nix` — entry point for `home-manager switch`:

- Loads nixpkgs for the host's system
- Passes **no** `extraSpecialArgs` (the module is self-contained)
- Imports `./default.nix`

Template: `home-manager-pancho/standalone.nix`

### 2. Register in flake.nix

Add a `homeConfigurations.<user>` entry:

```nix
<user> =
  home-manager.lib.homeManagerConfiguration
  (import ./home-manager-<user>/standalone.nix {inherit nixpkgs;});
```

### 3. Add the NixOS user

In `hosts/<host>/nixos/configuration.nix`:

1. Define the user:

```nix
users.users.<user> = {
  isNormalUser = true;
  description = "<Full Name>";
  shell = pkgs.<shell>;
};
```

2. Wire Home Manager:

```nix
home-manager.users.<user> = import ../../../home-manager-<user>;
```

Do **not** add `wheel` or other privileged groups unless explicitly requested.

### 4. Verify

```bash
home-manager switch --flake .#<user> --dry-run
```

### 5. Report

Tell the user:

- The new username and host
- The flake name: `home-manager switch --flake .#<user>`
- That the new user can clone the repo and run `home-manager switch --flake .#<user>` to update their own config
- That the new user can open PRs against this repo to add packages to their config
- That a system rebuild (`sudo nixos-rebuild switch --flake .#<host>`) is required to create the Linux user
- That the new user's SSH public key needs to be added for SSH access
