{
  config,
  lib,
  theme,
  ...
}: {
  home.activation.writeGhosttyTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cat > ${config.home.homeDirectory}/.dotfiles/dotfiles/ghostty/config << EOF
    # Font configuration
    font-family = JetBrains Mono
    font-size = 14
    font-style = bold

    # Theme colors
    background = ${theme.bg}
    foreground = ${theme.fg}
    cursor-color = ${theme.accent}
    selection-background = ${theme.bg_secondary}
    selection-foreground = ${theme.fg}

    # Terminal colors
    palette = 0=${theme.bg}
    palette = 1=${theme.red}
    palette = 2=${theme.green}
    palette = 3=${theme.yellow}
    palette = 4=${theme.blue}
    palette = 5=${theme.purple}
    palette = 6=${theme.cyan}
    palette = 7=${theme.fg}
    palette = 8=${theme.bg_secondary}
    palette = 9=${theme.red}
    palette = 10=${theme.green}
    palette = 11=${theme.yellow}
    palette = 12=${theme.blue}
    palette = 13=${theme.purple}
    palette = 14=${theme.cyan}
    palette = 15=${theme.fg}

    # Key bindings
    keybind = command+a=esc:a
    keybind = unconsumed:command+g=esc:g

    # Clipboard settings
    clipboard-read = allow
    clipboard-write = allow
    clipboard-paste-protection = false
    clipboard-paste-bracketed-safe = true
    copy-on-select = true
    term = "xterm-256color"
    EOF
  '';
}
