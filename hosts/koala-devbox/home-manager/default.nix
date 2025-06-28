{
  config,
  pkgs,
  lib,
  theme,
  ...
}: {
  imports = [
    ../../../home-manager/common/home.nix
    ../../../home-manager/linux/desktop.nix
    ../../../home-manager/linux/packages.nix
    ../../../home-manager/linux/gpg.nix
    ./plasma-config.nix
    ./packages.nix
  ];

  # Override workspace theme settings from dumped plasma-config.nix
  programs.plasma.workspace = {
    lookAndFeel = theme.plasma_look_and_feel;
    colorScheme = theme.plasma_color_scheme;
    theme = theme.plasma_theme;
    iconTheme = theme.plasma_icon_theme;
    cursor.theme = theme.plasma_cursor_theme;
    wallpaper = theme.plasma_wallpaper;
  };
}
