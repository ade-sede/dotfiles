{ config, pkgs, ... }:

{
  # Symlink dotfiles from the repository
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/nvim";
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/git/.gitconfig";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/ghostty";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/starship.toml";
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/sway";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/waybar";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/dunst";
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/emacs";
    ".config/kanshi".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/kanshi";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "/home/ade-sede/.dotfiles/dotfiles/swaylock";
  };
}
