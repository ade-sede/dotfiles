# bat config — sets the syntax-highlighting theme from the active color palette.
{
  config,
  pkgs,
  theme,
  ...
}: {
  programs.bat = {
    enable = true;
    config = {
      theme = theme.bat_theme;
      style = "plain";
      pager = "less -FR";
    };
  };
}
