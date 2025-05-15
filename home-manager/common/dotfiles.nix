{
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/nvim";
    ".config/home-manager".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home-manager";
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/git/.gitconfig";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/ghostty";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/starship.toml";
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/sway";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/waybar";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/dunst";
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/emacs";
    ".config/kanshi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/kanshi";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/swaylock";
    ".codex".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dotfiles/codex";
  };
}
