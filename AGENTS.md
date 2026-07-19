## Build, Lint, and Test

- **Build/Update User:** `home-manager switch --flake .#<flake-name>`
- **Build/Update System:** `sudo nixos-rebuild switch --flake .#<flake-name>` You do not have permission to use this command
- **Finding out which flake to use on a given machine:** Check `homeConfigurations` keys in `flake.nix`. Run `hostname` as a hint, but the actual name must match a key in `homeConfigurations`.
- **Lint:** Pre-commit hooks handle linting with `alejandra` (Nix) and `mdformat` (Markdown). Run `pre-commit install`.
- **Test:** No dedicated test command. Builds are the primary validation.

## Git and Pre-commit Hooks

- **Pre-commit hooks:** Run automatically on commit and may modify files (especially formatting)
- **Important:** If pre-commit hooks modify files during commit, the commit fails and you MUST re-add the modified files
- **Workflow:** After failed commit due to formatting, run `git add .` and `git commit` again with the same message

## Code Style

- **Comments:** Avoid at all cost.
- **Formatting:** Use `alejandra` for Nix and `mdformat` for Markdown. Never submit unformatted code.
- **Imports:** Follow existing patterns in `.nix` files.
- **Types:** Not strictly applicable; Nix is a dynamically typed language.
- **Naming Conventions:** Use `camelCase` for variables and `kebab-case` for file names.
- **Error Handling:** Ensure Nix expressions are valid and evaluate correctly.
- **Packages:** Add new packages to `home-manager/common/packages.nix` or `home-manager/linux/packages.nix`.
- **Dotfiles:** Add new dotfiles to `dotfiles/` and symlink in `home-manager/common/dotfiles.nix`.
- **Secrets:** Use `gitleaks` for secret scanning (part of pre-commit) and store secrets in `secrets/` at the repo root which is gitignored

## Documentation

- **Opencode:** Read online at https://opencode.ai/docs/

> **Note:** This file governs how agents interact with *this repository*. Agent docs under `dotfiles/claude/` and `dotfiles/opencode/` are application configs symlinked to `~/.config/` that govern AI agent behavior on the machine itself.
