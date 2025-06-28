# Theme Configuration Inventory

This document provides a comprehensive inventory of all theme and color configurations across the dotfiles repository. Each entry includes the file path, line number, and specific configuration details.

## Summary

The repository contains theme configurations for the following applications:

- **Terminal Applications**: Neovim, Tmux, Starship, Ghostty, Kitty
- **System UI**: Waybar, Sway, Swaylock, Dunst
- **Development Tools**: Bat, OpenCode
- **System Components**: Plymouth bootloader, TTY daemon
- **Utilities**: FZF

## Detailed Inventory

### Neovim Theme Configurations

#### Color Scheme Selection

- **File**: `dotfiles/nvim/after/plugin/color.lua:15`
  - **Current**: `vim.cmd("colorscheme github_light_tritanopia")`
  - **Alternatives**: carbonfox, ayu (commented out)

#### Color Palette Customization

- **File**: `dotfiles/nvim/after/plugin/color.lua:3-7`
  - **Carbonfox palette**: Custom bg1 = "#000000"

#### Theme Plugins

- **File**: `dotfiles/nvim/lua/plugins/github-theme.lua:1`
  - **Plugin**: projekt0n/github-nvim-theme
- **File**: `dotfiles/nvim/lua/plugins/ayu.lua:1`
  - **Plugin**: ayu-theme/ayu-vim
- **File**: `dotfiles/nvim/lua/plugins/onedark.lua:1`
  - **Plugin**: navarasu/onedark.nvim
- **File**: `dotfiles/nvim/lua/plugins/dracula.lua:1`
  - **Plugin**: Mofiqul/dracula.nvim

#### Dashboard Theme

- **File**: `dotfiles/nvim/lua/plugins/dashboard.lua:6`
  - **Theme**: "hyper"

### Terminal Emulator Themes

#### Ghostty

- **File**: `dotfiles/ghostty/config:3`
  - **Theme**: "Github"

#### Kitty

- **File**: `dotfiles/kitty/3024_Night.conf:1-21`
  - **Complete color scheme**: 3024 Night theme with 16 colors
  - **Background**: #090200
  - **Foreground**: #a4a1a1
  - **Cursor**: #a4a1a1

### System UI Themes

#### Waybar

- **File**: `dotfiles/waybar/style.css`
  - **Primary colors**: Black backgrounds (#000000), white text (#ffffff)
  - **Lines**: 12, 18, 27, 46, 65-66, 70, 75-76, 81-82, 87-88, 97, 101-102, 106-107, 110-111, 116-117, 121, 125-126, 130-131, 135-136, 141, 145, 149, 153, 157, 161, 165-166, 170-171, 175, 179, 183, 187-188

#### Sway Window Manager

- **File**: `dotfiles/sway/config:34`
  - **Background**: `output * bg #000000 solid_color`
- **File**: `dotfiles/sway/config:256-260` (commented)
  - **Bar colors**: statusline #ffffff, background #000000, workspace colors

#### Swaylock

- **File**: `dotfiles/swaylock/config:1`
  - **Color**: 000000 (black)

#### Dunst Notifications

- **File**: `dotfiles/dunst/dunstrc`
  - **Frame color**: #ffffff (line 106)
  - **Normal background**: #1e202b, foreground: #ffffff (lines 336-337)
  - **Low background**: #1e202b, foreground: #ffffff (lines 343-344)
  - **Critical background**: #900000, foreground: #000000 (lines 351-352)

### Shell and Prompt Themes

#### Starship Prompt

- **File**: `dotfiles/starship.toml`
  - **Username**: bold #7dcfff (bright cyan) - line 16
  - **Directory**: bold #9ece6a (vibrant green) - line 20
  - **Error symbol**: bold #ff5555 (red) - line 23
  - **Success symbol**: bold #50fa7b (green) - line 24
  - **Git branch**: bold #bb9af7 (light purple) - line 28
  - **Git status**: bold #f7768e (soft red) - line 31

#### Tmux

- **File**: `home-manager/common/tmux.nix:23`
  - **Theme**: tokyo-night-tmux with 'day' variant
- **File**: `home-manager/common/tmux.nix:13,37`
  - **Terminal**: screen-256color, tmux-256color

### Development Tools

#### Bat (File Viewer)

- **File**: `home-manager/common/programs.nix:18`
  - **Theme**: "GitHub"

#### OpenCode

- **File**: `dotfiles/opencode/config.json:3`
  - **Theme**: "tokyonight"

#### FZF (Fuzzy Finder)

- **File**: `home-manager/common/scripts/tmux-switch-pane.sh:3`
  - **Color options**: Custom FZF_DEFAULT_OPTS with color settings

### System Components

#### Plymouth Bootloader

- **File**: `hosts/koala-devbox/nixos/bootloader.nix:12-15`
  - **Theme**: "colorful_loop"
  - **Package**: adi1090x-plymouth-themes

#### TTY Daemon (Remote Terminal)

- **File**: `hosts/remote-devbox/nixos/services.nix:65`
  - **Theme**: JSON object with background: "white", foreground: "black"
  - **Font**: InconsolataGo Nerd Font, JetBrains, SarasaMono

## Theme Categories

### Light Themes

- Neovim: github_light_tritanopia
- Ghostty: Github
- Bat: GitHub
- Tmux: tokyo-night 'day' variant
- TTY daemon: white background, black foreground

### Dark Themes

- Kitty: 3024_Night (dark theme)
- Waybar: Black backgrounds with white text
- Sway: Black background
- Swaylock: Black
- Dunst: Dark backgrounds (#1e202b)

### Colorful/Accent Themes

- Starship: Tokyo Night inspired colors (cyan, green, purple, red)
- OpenCode: tokyonight
- Plymouth: colorful_loop

## Notes

1. **Inconsistent theme approach**: Some applications use light themes (GitHub-style) while others use dark themes
1. **Hardcoded values**: Most color values are hardcoded rather than using variables
1. **Mixed color schemes**: Tokyo Night, GitHub, and custom colors are mixed throughout
1. **No centralized theme management**: Each application manages its own theme independently

## Recommendations for Centralization

1. Create a central theme module defining color palettes
1. Use Nix variables to propagate theme choices
1. Standardize on a consistent color scheme across all applications
1. Implement theme switching mechanism (light/dark/custom variants)
