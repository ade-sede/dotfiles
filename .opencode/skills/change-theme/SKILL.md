______________________________________________________________________

## name: change-theme description: Use when changing the UI color theme, switching between dark mode and light mode, enabling the dracula colorscheme, updating the visual appearance of terminals, editors, and the desktop environment, or adding a brand new theme variant to the dotfiles.

# Change Theme

## Available themes

| Variant | Description |
|-----------|-------------------------------------------------------------|
| `dark` | GitHub dark — dark navy background, blue accents |
| `light` | GitHub light — white background, blue accents |
| `dracula` | Dracula — dark purple background, vivid purple/pink accents |

## What a theme change affects

Changing `theme.variant` in `constants.nix` re-generates configuration for:

- **Ghostty / Kitty** — full 16-color ANSI palette, background, foreground, cursor, selection
- **Neovim** — colorscheme (`carbonfox` / `github_light_tritanopia` / `dracula`)
- **tmux** — tokyo-night-tmux plugin theme (`night` / `day`)
- **bat** — syntax highlighting theme
- **fish** — built-in theme + selection color
- **eza / ls** — `EZA_COLORS` / `LS_COLORS` environment variables
- **atuin** — shell history UI role-based colors
- **KDE Plasma** — look-and-feel, color scheme, icon theme, cursor theme, wallpaper

## Theme config location

Each host's active theme is set in `hosts/<flake-name>/constants.nix`:

```nix
theme = {
  variant = "dark"; # one of: "light", "dark", "dracula"
};
```

## Switching to an existing theme

1. Use the `detect-machine` skill to determine the current flake name.
1. Read `hosts/<flake-name>/constants.nix` and show the current `theme.variant`.
1. Ask the user which variant they want: `light`, `dark`, or `dracula`.
1. Edit `hosts/<flake-name>/constants.nix` — update `theme.variant` to the chosen value.
1. Ask the user whether to rebuild now to apply the change.
1. If yes, use the `rebuild-system` skill.

______________________________________________________________________

## Adding a new theme

### Step 1 — Source the color palette

Find the authoritative hex values for the theme. Prefer sources in this order:

1. The theme's official website (e.g. `draculatheme.com`, `catppuccin.com`)
1. The theme's GitHub repository — look for a palette file, README color table, or `colors.yml`
1. An existing terminal emulator port (Ghostty, Kitty, Alacritty, Windows Terminal) — these are the most reliable because they already map colors to the same ANSI slots used here

The palette needs at minimum: background, foreground, and the 8 standard ANSI colors (black, red, green, yellow, blue, magenta, cyan, white). The "bright" variants of those 8 are used for `bg_secondary` and similar secondary UI slots.

### Step 2 — Add the new variant to `themes/colors.nix`

Add a new top-level key to `themes/colors.nix`. Every field is required. Follow the structure of the existing variants exactly.

#### Base colors

| Field | What to use |
|----------------|----------------------------------------------------------------|
| `bg` | Main background color |
| `fg` | Main foreground / text color |
| `bg_secondary` | Secondary background — typically ANSI bright-black / color 8 |
| `selection` | Text selection highlight — often a muted accent or color 8 |
| `border` | UI border — often between `bg` and `bg_secondary` |
| `accent` | Cursor and active-element color — often the theme's main accent|

#### Status colors

Map these to the theme's corresponding semantic colors:

| Field | Typical mapping |
|-----------|--------------------------|
| `success` | Theme's green |
| `warning` | Theme's yellow or orange |
| `error` | Theme's red |
| `info` | Theme's blue or cyan |

#### Syntax / ANSI colors

Map directly from the theme's ANSI color definitions (colors 1–6):

| Field | ANSI slot |
|----------|-----------|
| `red` | Color 1 |
| `green` | Color 2 |
| `yellow` | Color 3 |
| `blue` | Color 4 |
| `purple` | Color 5 |
| `cyan` | Color 6 |

#### Application-specific string fields

| Field | How to choose |
|----------------------|-----------------------------------------------------------------------------------------------------|
| `neovim_colorscheme` | The exact string passed to `vim.cmd("colorscheme ...")` — see Step 3 for plugin requirements |
| `bat_theme` | A bat built-in theme name — run `bat --list-themes` to see all available options |
| `tmux_theme` | Only `"night"` or `"day"` are valid (tokyo-night-tmux constraint) — use `"night"` for dark themes |
| `fish_theme` | Informational only — not read by `fish.nix` (which branches on `variant` instead) |

#### atuin theme

The `atuin_theme` attrset uses **CSS named color strings** (not hex). Pick values that approximate the palette.
Reference: https://developer.mozilla.org/en-US/docs/Web/CSS/named-color

```nix
atuin_theme = {
  Base        = "ghostwhite";      # default text
  Important   = "cornflowerblue"; # highlighted items
  AlertInfo   = "cornflowerblue"; # info messages
  AlertWarn   = "goldenrod";      # warnings
  AlertError  = "tomato";         # errors
  Guidance    = "mediumpurple";   # hints
  Annotation  = "mediumturquoise";# annotations
};
```

#### KDE Plasma fields (koala-devbox only)

| Field | How to find the value |
|------------------------|------------------------------------------------------------------------------------------------------------|
| `plasma_look_and_feel` | The Look-and-Feel package ID — check `~/.local/share/plasma/look-and-feel/` or the package's `metadata.json` |
| `plasma_color_scheme` | The color scheme name — check `~/.local/share/color-schemes/` for installed schemes |
| `plasma_theme` | The Plasma shell theme name — check `~/.local/share/plasma/desktoptheme/` |
| `plasma_icon_theme` | Icon theme name — check `~/.local/share/icons/` |
| `plasma_cursor_theme` | Cursor theme name — check `~/.local/share/icons/` (cursors live alongside icon themes) |
| `plasma_wallpaper` | Absolute path — add the wallpaper file to `wallpapers/` in the dotfiles repo |

KDE theme packages are not managed by Home Manager — they must already be installed on the system. Verify before setting these fields.

### Step 3 — Per-application extra steps

Most apps need nothing beyond `colors.nix`. The exceptions:

#### Neovim — colorscheme plugin

If the desired colorscheme is not already installed, add a plugin file:

```
dotfiles/nvim/lua/plugins/<theme-name>.lua
```

Follow the pattern of existing files (e.g. `dracula.lua`, `nightfox.lua`). The plugin will be installed automatically by lazy.nvim on the next Neovim startup after rebuild. Existing colorscheme plugins already installed:

- `carbonfox`, `nightfox`, etc. → `EdenEast/nightfox.nvim`
- `github_light_tritanopia`, etc. → `projekt0n/github-nvim-theme`
- `dracula` → `Mofiqul/dracula.nvim`
- `ayu` → `ayu-theme/ayu-vim`
- `onedark` → `navarasu/onedark.nvim`

#### Fish — theme branch

`fish.nix` branches on `variant` to select the Fish built-in theme. If the new variant name is not `"light"` or `"dracula"`, it falls through to `Tomorrow Night` (the dark default). To use a different Fish built-in theme, add a branch in `home-manager/common/programs/fish.nix`:

```nix
${if theme.variant == "your-variant" then ''fish_config theme choose "Theme Name"''
  else if theme.variant == "light" then ''fish_config theme choose "ayu Light"''
  else if theme.variant == "dracula" then ''fish_config theme choose "Dracula"''
  else ''fish_config theme choose "Tomorrow Night"''}
```

Run `fish_config theme list` to see available built-in Fish themes.

#### bat — theme availability

Not all theme names are built into bat. Run `bat --list-themes` to confirm the desired theme exists before setting `bat_theme`. If it is not available, fall back to `"base16"` (universally available, adapts to the terminal palette).

#### tmux — no new plugin needed

The tokyo-night-tmux plugin only supports `"night"` and `"day"`. No new plugin or package is required regardless of theme.

#### Ghostty / Kitty / atuin / starship

No extra steps — all are driven purely by hex values from `colors.nix`.

### Step 4 — Wire the new variant

1. Add the new key to `themes/colors.nix`
1. Make any per-application changes from Step 3
1. Set `theme.variant = "<new-name>"` in `hosts/<flake-name>/constants.nix`
1. Use the `rebuild-system` skill to apply
