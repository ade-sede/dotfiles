{
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/nvim";
    ".config/home-manager".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/home-manager";
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/git/.gitconfig";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/ghostty";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/starship.toml";
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/sway";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/waybar";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/dunst";
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/emacs";
    ".config/kanshi".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/kanshi";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/swaylock";
    ".codex".source = config.lib.file.mkOutOfStoreSymlink "~/.dotfiles/dotfiles/codex";
  };
}
