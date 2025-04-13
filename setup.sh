#!/usr/bin/env sh

OVERRIDE_EXISTING=false

for arg in "$@"; do
  case "$arg" in
    --override-existing-configs)
      OVERRIDE_EXISTING=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--override-existing-configs]"
      exit 1
      ;;
  esac
done

mkdir -p ~/.config
mkdir -p ~/.local/share/devbox/global/default
mkdir -p ~/.tmux/plugins
mkdir -p ~/.config/kitty

handle_config() {
  local target="$1"
  local link="$2"
  
  if [ -e "$link" ]; then
    if [ "$OVERRIDE_EXISTING" = true ]; then
      echo "Removing existing $link"
      rm -rf "$link"
      echo "Creating symlink: $link -> $target"
      ln -s "$target" "$link"
    else
      echo "Skipping $link (already exists)"
    fi
  else
    echo "Creating symlink: $link -> $target"
    ln -s "$target" "$link"
  fi
}

echo "Setting up plugins..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  tmux run-shell ~/.tmux/plugins/tpm/bin/install_plugins
else
  echo "TPM already installed"
  if [ "$OVERRIDE_EXISTING" = true ]; then
    echo "Updating TPM..."
    cd ~/.tmux/plugins/tpm && git pull
  fi
fi

if [ ! -d ~/.config/kitty/kitty-themes ]; then
  echo "Installing kitty-themes..."
  git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
else
  echo "kitty-themes already installed"
  if [ "$OVERRIDE_EXISTING" = true ]; then
    echo "Updating kitty-themes..."
    cd ~/.config/kitty/kitty-themes && git pull
  fi
fi

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > /tmp/omf-install
fish /tmp/omf-install --noninteractive --yes
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "Setting up configuration files..."
handle_config ~/.dotfiles/fish ~/.config/fish
handle_config ~/.dotfiles/nvim ~/.config/nvim
handle_config ~/.dotfiles/starship.toml ~/.config/starship.toml
handle_config ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
handle_config ~/.dotfiles/git/.gitconfig ~/.gitconfig
handle_config ~/.dotfiles/kitty ~/.config/kitty
handle_config ~/.dotfiles/ghostty ~/.config/ghostty
handle_config ~/.dotfiles/devbox/devbox.json ~/.local/share/devbox/global/default/devbox.json


echo "Setup completed successfully!"
