______________________________________________________________________

## name: update-config description: Use when making any configuration change to the dotfiles — adding or removing packages, changing program settings, editing dotfiles, creating new Nix modules, or modifying any existing Nix file. Guides the agent to identify the correct scope and target file for the change before editing anything.

# Update Config

## How to navigate this repository

Every directory has a `README.md` describing its responsibility. Every `.nix` file has a single-line comment at the top describing what it configures and who it applies to. Always read these before deciding where a change belongs.

### Navigation workflow

1. Start at the repo root and identify the broad area (Home Manager vs NixOS vs themes).
1. Read the `README.md` of candidate directories to understand scope.
1. Read the docstring at the top of candidate `.nix` files to confirm the right target.
1. Only then make the change.

Do not guess file locations from memory — the structure may have changed since you were trained. Always explore dynamically.

## Scope decision

Before touching any file, answer: **"Which machines need this change?"**

| Scope | Where to look |
|-------------------------------------------------|-----------------------------------------------------------------|
| All hosts (Linux + macOS) | `home-manager/common/` — read its README, then pick the right file |
| Both Linux hosts only | `home-manager/linux/` — read its README |
| Single host only | `hosts/<name>/home-manager/` — read its README |
| NixOS system level (all NixOS hosts) | `nixos/common/` — read its README |
| NixOS system level (Linux hosts) | `nixos/linux/` — read its README |
| NixOS system level (single host) | `hosts/<name>/nixos/` — read its README |
| Theme / colors | Use the `change-theme` skill instead |

## Rules

- New program config files under `home-manager/common/programs/` must be added as imports in `home-manager/common/home.nix`.
- New host-specific files must be added as imports in `hosts/<name>/home-manager/default.nix`.
- Never add Linux-only packages to `home-manager/common/`.
- Never add GUI/desktop packages to the shared Linux packages file — check `home-manager/linux/` READMEs to find the right file.
- For theme changes, delegate to the `change-theme` skill.
- After changes are made, offer to rebuild using the `rebuild-system` skill.

## Workflow

1. Understand the change being requested.
1. Answer the scope question: which machines need this?
1. Navigate to the candidate directory and read its `README.md`.
1. Read the docstring of the specific file before editing it.
1. Make the change, following existing patterns in the file.
1. If a new file is created, add its import to the appropriate parent module.
1. Offer to rebuild using the `rebuild-system` skill.
