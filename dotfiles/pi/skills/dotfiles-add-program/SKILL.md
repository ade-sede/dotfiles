______________________________________________________________________

## name: dotfiles-add-program description: > Scaffold a new program: create the config module in home-manager/common/programs/, add packages, wire dotfile symlinks, and rebuild. Audits theme coverage and ensures all imports are correct.

# Dotfiles Add Program

Use this skill when adding a new program to the dotfiles configuration.

## Workflow

### 1. Discover

Read the following to understand existing patterns:

- `home-manager/common/programs/README.md` — what this directory is for
- `home-manager/common/home.nix` — how modules are imported (the master list)
- Pick one existing program module to use as a template (prefer the most structurally similar program)

Also check `themes/colors.nix` to see what theme keys already exist. If the program needs theme support, note which keys are missing.

### 2. Plan

Decide on the module structure:

- **Simple program** (no theme): Just config, no `theme` in specialArgs. Template: `direnv.nix`.
- **Themed program** (reads colors): Uses `theme` specialArg, reads from `themes/colors.nix`. Template: `bat.nix`, `kitty.nix`, or `starship.nix`.
- **Activation script** (generates config files): Uses `home.activation` to write files into the dotfiles tree. Template: `neovim.nix`, `ghostty.nix`.

Tell the user the plan and wait for confirmation.

### 3. Create Module

Create `home-manager/common/programs/<name>.nix`:

- Match the pattern of the template: same import structure, same specialArgs
- If themed: read the relevant keys from `themes/colors.nix` and apply them
- If it generates config files: use `lib.hm.dag.entryAfter ["writeBoundary"]` activation
- The module must accept `config`, `pkgs`, `lib`, `theme` (if themed), and `...` as parameters

### 4. Register

- Add the module import to `home-manager/common/home.nix` in the programs section
- Add the package to `home-manager/common/packages.nix` if it's a standalone package
- If the program has a dotfile config, add a symlink entry to `home-manager/common/dotfiles.nix`

### 5. Audit Theme Coverage

If the program is themed:

- Read `themes/colors.nix` and verify all theme keys referenced in the module exist
- If the program uses a colorscheme/name that should vary per variant, ensure it's in `colors.nix` under each variant
- Report any gaps: "Program X references `theme.foo` but `foo` is not defined in any theme variant"

### 6. Rebuild

```bash
home-manager switch --flake .#<flake-name>
```

Auto-detect the flake name from `hostname` by matching against the keys in `flake.nix`'s `homeConfigurations`. If hostname doesn't match any key, ask the user.

If the rebuild fails, read the error, fix the issue, and retry. Do not ask the user to debug Nix errors — handle them yourself.

### 7. Report

Tell the user:

- What was created
- Which programs/hosts it applies to (common = all hosts)
- Whether theme coverage is complete or has gaps
- The flake name used for rebuild
