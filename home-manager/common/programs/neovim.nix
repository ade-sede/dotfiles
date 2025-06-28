{
  config,
  pkgs,
  lib,
  theme,
  ...
}: {
  home.activation.writeNeovimTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # This is a bit of a hack to write a file directly into the source tree
    # during the build. This is necessary to have a file that is both
    # dynamically generated based on the theme, and also part of the
    # source-controlled dotfiles, so that it can be symlinked without
    # causing issues with home-manager.
    cat > ${config.home.homeDirectory}/.dotfiles/dotfiles/nvim/after/plugin/color.lua << EOF
    vim.g.ayucolor = "${
      if theme.variant == "light"
      then "light"
      else "dark"
    }"
    vim.cmd("colorscheme ${theme.neovim_colorscheme}")
    EOF
  '';
}
