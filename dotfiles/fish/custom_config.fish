fish_vi_key_bindings

function gitclean
    git branch --merged develop | grep -v "^\* develop" | xargs -n 1 -r git branch -d
end

function man
    bash -c "man $argv"
end

set --universal nvm_default_version v22.2.0
set -x PATH "$HOME/.nix-profile/bin" $PATH
set -x PATH "/nix/var/nix/profiles/default/bin" $PATH
set -x GOPATH "$HOME/.go"
set -x GPG_TTY (tty)
set -x LANG en_US.UTF-8
set -x NVM_DIR "$HOME/.nvm"
set -x XDG_CONFIG_HOME ~/.config
set -x XDG_DATA_HOME ~/.local/share
set -x DOTFILES "$HOME/.dotfiles"
if [ -d ~/.alan ]
	alias ls="eza --icons"
	set -x MAIL "adrien.de-sede@alan.eu"
	set -x COMPANY "ALAN"
else
	set -x MAIL "adrien.de.sede@gmail.com"
	alias ls="exa --icons"
end
set -x EDITOR "vim"
set -x PATH "$DOTFILES/scripts:$PATH"
set -x PATH "$HOME/.cargo/bin:$PATH"
set -x PATH "/var/lib/snapd/snap/bin:$PATH"
set -x PATH "$HOME/.local/bin:$PATH"
set -x PATH "$HOME/bin:$PATH"
set -x PATH "/usr/local/go/bin:$PATH"
set -x PATH "$GOPATH/bin:$PATH"
set -x LIBRARY_PATH "$LIBRARY_PATH:/usr/local/lib"
set -x LESS "-SRXF"
set -x SHELL (which fish)
set -U Z_CMD "j"
set -U Z_OWNER $USER
set -x VIMRC "$HOME/.config/nvim/init.vim"
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -x ANSIBLE_NOCOWS 1
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x LC_MESSAGES en_US.UTF-8
set -x LC_TIME fr_FR.UTF-8
set -x LC_NUMERIC fr_FR.UTF-8
set -x LC_MONETARY fr_FR.UTF-8
set -x LC_PAPER fr_FR.UTF-8
set -x LC_MEASUREMENT fr_FR.UTF-8
set -x LC_COLLATE fr_FR.UTF-8
set -x LC_NAME fr_FR.UTF-8
set -x LC_ADDRESS fr_FR.UTF-8
set -x LC_TELEPHONE fr_FR.UTF-8

# Leave LC_ALL unset to allow individual category settings to take effect

if [ -d ~/.zvm ]
    set -x ZVM_INSTALL $HOME/.zvm/self
    alias zvm $HOME/.zvm/self/zvm
    set -x PATH $HOME/.zvm/bin:$PATH
end
if [ -e ~/.openai-nvim-key ]
    set -x OPENAI_API_KEY (cat ~/.openai-nvim-key | tr -d '\n')
end
if [ -e ~/.anthropic-nvim-key ]
    set -x ANTHROPIC_API_KEY (cat ~/.anthropic-nvim-key | tr -d '\n')
end
if [ -e /usr/bin/fdfind ] && [ ! -e /usr/bin/fd ]
    alias fd="fdfind"
end 
if [ -e /usr/bin/batcat ] && [ ! -e /usr/bin/bat ]
    alias bat="batcat"
end 


alias grep="grep --color"
alias em="emacsclient -nw -a '' "
alias vem="emacsclient -nc -a '' "
alias vim="nvim"
alias v="nvim"
alias gvim="neovide"
alias kubectl="kubecolor"

if type -q devbox
    # devbox global shellenv --init-hook | source
end
if type -q bass
    bass source ~/.nvm/nvm.sh --no-use ';' nvm use $nvm_default_version > /dev/null 2>&1
end
if [ -e ~/.dotfiles/dotfiles/fish/scripts/greeting.fish ]
    source ~/.dotfiles/dotfiles/fish/scripts/greeting.fish
end
if [ -e ~/.asdf/asdf.fish ]
    source ~/.asdf/asdf.fish
end
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
if [ -e $HOME/.opam/opam-init/init.fish ]
    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
end
if [ -e /opt/homebrew/bin/brew ]
    eval (/opt/homebrew/bin/brew shellenv)
end
if type -q starship
  starship init fish | source
end
if type -q direnv
  direnv hook fish | source
end
if type -q fzf
  fzf --fish | source
end
