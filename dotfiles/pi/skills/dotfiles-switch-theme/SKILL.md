______________________________________________________________________

## name: dotfiles-switch-theme description: > Switch the active theme variant (light/dark/dracula) for a host, audit all programs for missing theme coverage, and rebuild. Reports any programs that don't yet read from the theme system.

# Dotfiles Switch Theme

Use this skill to change the active theme variant and verify theme coverage across all programs.

## Workflow

### 1. Determine Target Variant

Ask the user which variant to switch to. Valid variants: `light`, `dark`, `dracula`.

### 2. Audit Theme Coverage

Before making any changes, audit all program modules for theme completeness:

Read every file in `home-manager/common/programs/`. For each module:

- **Does it accept `theme` as a specialArg?** If not, it's theme-blind.
- **If it accepts `theme`:** check that every `theme.<key>` it references exists in `themes/colors.nix` for the target variant.
- **Activation-based modules** (neovim, ghostty): verify the activation script reads from `theme` correctly.

Report findings:

```
Theme audit for variant "<variant>":
✓ bat — uses theme.bat_theme
✓ kitty — uses theme.bg, theme.fg, theme.accent, etc.
✓ neovim — uses theme.neovim_colorscheme, theme.selection
✗ direnv — no theme support (no theme keys needed)
✗ <new-program> — theme-blind (does not accept theme specialArg)
```

Flag any program that:

- Is themed but references a key missing from `colors.nix` for the target variant
- Is a GUI/terminal app but has no theme support at all

### 3. Add Missing Theme Keys (if any)

If programs reference keys that don't exist in `colors.nix`:

- Add the keys to all three variants (`light`, `dark`, `dracula`) in `themes/colors.nix`
- Use sensible defaults (match the existing pattern for that key name)
- If the key is program-specific (e.g., `bat_theme`), choose a theme name that matches the variant

### 4. Switch the Variant

Read `README.md#theme-switching` for the procedure.

Edit `hosts/<name>/constants.nix`:

```nix
theme = {
  variant = "<new-variant>";
};
```

### 5. Rebuild

Auto-detect the flake name from `hostname` by matching against `flake.nix`'s `homeConfigurations` keys.

Rebuild both scopes (NixOS if Linux, Home Manager):

```bash
# Linux desktop: both
sudo nixos-rebuild switch --flake .#<name>
home-manager switch --flake .#<name>

# Linux server: both
sudo nixos-rebuild switch --flake .#<name>
home-manager switch --flake .#<name>

# macOS: HM only
home-manager switch --flake .#<name>
```

If hostname doesn't match any key, ask the user.

### 6. Report

Tell the user:

- Previous variant → new variant
- Theme audit results (complete / any gaps)
- What was rebuilt
- Any programs flagged as theme-blind that should be updated
