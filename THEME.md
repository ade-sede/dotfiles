# Theme Injection System

This document explains how the theme injection system works for these dotfiles.

There are two primary methods for applying themes to applications:

1. **Direct Theme Selection**: Using a simple option in the program's Home Manager module to set a theme by name.
1. **In-line Structured Theming**: Defining the entire theme structure as a Nix attribute set within the module, which Home Manager then uses to generate the configuration file.

## 1. Direct Theme Selection

This is the most straightforward method. It is used when the Home Manager module for a program provides a simple option to select a theme by name.

### Example: `bat.nix`

The `bat` configuration in `home-manager/common/programs/bat.nix` demonstrates this. The `theme` option is set to a simple string derived from our central theme definition.

```nix
{
  config,
  pkgs,
  theme,
  ...
}: {
  programs.bat = {
    enable = true;
    config = {
      # The theme name is supplied from our central theme definition.
      theme = theme.bat_theme;
    };
  };
}
```

## 2. Configuration File Generation via Activation Script

This method uses Home Manager activations to write configuration files into the `.dotfiles` directory during activation. The file is generated from the theme attribute set and committed to the source tree so it can be symlinked by Home Manager.

### Example: `neovim.nix`

In `home-manager/common/programs/neovim.nix`:

```nix
{
  config,
  pkgs,
  lib,
  theme,
  ...
}: {
  home.activation.writeNeovimTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cat > ${config.home.homeDirectory}/.dotfiles/dotfiles/nvim/after/plugin/color.lua << EOF
    vim.g.ayucolor = "${
      if theme.variant == "light" then "light" else "dark"
    }"
    vim.cmd("colorscheme ${theme.neovim_colorscheme}")
    EOF
  '';
}
```

This activation writes `color.lua` into the `.dotfiles` workspace so it can be tracked in Git and symlinked during activation.
