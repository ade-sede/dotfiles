#!/usr/bin/env sh

# RIP my emacs days
#mkdir -p ~/.emacs.d
#ln -s ~/.dotfiles/emacs/.emacs ~/.emacs
#ln -s ~/.dotfiles/emacs/emacs.org ~/.emacs.d/emacs.org
#ln -s ~/.dotfiles/emacs/snippets/ ~/.emacs.d/snippets

ln -s ~/.dotfiles/fish ~/.config/fish
ln -s ~/.dotfiles/nvim ~/.config/nvim
#ln -s ~/.dotfiles/dunst ~/.config/dunst
#ln -s ~/.dotfiles/sway ~/.config/sway
ln -s ~/.dotfiles/starship.toml ~/.config/starship.toml
ln -s ~/.dotfiles/tmux/.tmux ~/.tmux
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
#ln -s ~/.dotfiles/Wallpaper ~/Wallpaper
ln -s ~/.dotfiles/kitty ~/.config/kitty
#ln -s ~/.dotfiles/kanshi ~/.config/kanshi
#ln -s ~/.dotfiles/waybar ~/.config/waybar
#ln -s ~/.dotfiles/swaylock ~/.config/swaylock
#ln -s ~/.dotfiles/conky ~/.config/conky
ln -s ~/.dotfiles/ghostty ~/.config/ghostty

mkdir -p ~/.local/share/devbox/global/default
ln -s ~/.dotfiles/devbox/devbox.json ~/.local/share/devbox/global/default

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes


curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
