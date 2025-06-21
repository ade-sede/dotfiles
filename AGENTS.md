## Build, Lint, and Test

- **Build/Update System:** `sudo nixos-rebuild switch --flake .#<flake-name>`
- **Build/Update User:** `home-manager switch --flake .#<flake-name>`
- **Lint:** Pre-commit hooks handle linting with `alejandra` (Nix) and `mdformat` (Markdown). Run `pre-commit install`.
- **Test:** No dedicated test command. Builds are the primary validation.

## Code Style

- **Formatting:** Use `alejandra` for Nix and `mdformat` for Markdown.
- **Imports:** Follow existing patterns in `.nix` files.
- **Types:** Not strictly applicable; Nix is a dynamically typed language.
- **Naming Conventions:** Use `camelCase` for variables and `kebab-case` for file names.
- **Error Handling:** Ensure Nix expressions are valid and evaluate correctly.
- **Packages:** Add new packages to `home-manager/common/packages.nix` or `home-manager/desktop-linux`.
- **Dotfiles:** Add new dotfiles to `dotfiles/` and symlink in `home-manager/common/dotfiles.nix`.
- **Secrets:** Use `gitleaks` for secret scanning (part of pre-commit) and store secrets in `dotfiles/secrets` which is gitignored

## Documentation

- **Opencode:** Read online at https://opencode.ai/docs/
