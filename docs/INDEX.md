# Documentation Index

Quick links organized by what you want to do.

## Getting Started

- [README.md](../README.md) — repo overview, structure, and setup commands
- [Adding a New Host](../README.md#adding-a-new-host) — step-by-step guide in README.md

## Managing Machines

- [NixOS](nixos/README.md) — system-level config, generations, garbage collection
- [Home Manager](home-manager/README.md) — user-level config, adding dotfiles, importing Plasma
- [Hosts](hosts/README.md) — per-machine entry points and constants

## Per-Host Details

- [koala-devbox](hosts/koala-devbox/README.md) — NixOS desktop (KDE Plasma, Wayland)
- [remote-devbox](hosts/remote-devbox/README.md) — NixOS server (SSH, ttyd, nginx)
- [alan-macbook](hosts/alan-macbook/README.md) — macOS (Home Manager only)

## Themes

- [THEME.md](THEME.md) — how theme injection works (direct selection + config generation)
- [themes/](themes/README.md) — central color palette definitions

## Operations

- [Remote Development](REMOTE_DEV.md) — creating and deploying a Scaleway remote dev server
- [Key Management](KEY_MANAGEMENT.md) — generating and uploading GPG/SSH keys

## Development

- [AGENTS.md](../AGENTS.md) — rules for coding agents working on this repo
- [flake.nix](../flake.nix) — main entry point (documented in-file)

## Application Agent Configs (symlinked to ~/.config/)

- [Claude Code](dotfiles/claude/CLAUDE.md)
- [OpenCode](dotfiles/opencode/AGENTS.md)
- [Plannotator skills](dotfiles/claude/skills/)
