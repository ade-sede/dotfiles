{
  config,
  pkgs,
  theme,
  ...
}: {
  home.file.".config/kitty/theme.conf".text = ''
    background ${theme.bg}
    foreground ${theme.fg}
    cursor ${theme.accent}
    selection_background ${theme.bg_secondary}
    color0 ${theme.bg}
    color8 ${theme.bg_secondary}
    color1 ${theme.red}
    color9 ${theme.red}
    color2 ${theme.green}
    color10 ${theme.green}
    color3 ${theme.yellow}
    color11 ${theme.yellow}
    color4 ${theme.blue}
    color12 ${theme.blue}
    color5 ${theme.purple}
    color13 ${theme.purple}
    color6 ${theme.cyan}
    color14 ${theme.cyan}
    color7 ${theme.fg}
    color15 ${theme.fg}
  '';
}
