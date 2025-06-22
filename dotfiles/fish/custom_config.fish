fish_vi_key_bindings

function gitclean
    git branch --merged develop | grep -v "^\* develop" | xargs -n 1 -r git branch -d
end

function man
    bash -c "man $argv"
end

# OSC52 clipboard functions for seamless copy/paste
function copy
    printf '\033]52;c;%s\a' (cat | base64 | tr -d '\n')
end

function copyfile
    cat $argv | copy
end

function copypath
    pwd | copy
end

# Compatibility aliases for different clipboard tools
alias pbcopy='copy'
alias xclip='copy'
alias wl-copy='copy'

# GitHub-like color theme for exa/eza and ls - optimized for white backgrounds (no yellow)
set -x EZA_COLORS "di=1;38;5;75:ln=38;5;117:so=38;5;26:pi=38;5;26:ex=38;5;34:bd=38;5;68:cd=38;5;68:su=38;5;196:sg=38;5;196:tw=38;5;75:ow=38;5;75:fi=38;5;24:*.md=38;5;33:*.txt=38;5;24:*.nix=38;5;25:*.html=38;5;208:*.css=38;5;39:*.js=38;5;25:*.ts=38;5;26:*.json=38;5;67:*.yaml=38;5;29:*.yml=38;5;29:*.toml=38;5;66:*.ini=38;5;66:*.git=38;5;197:*.gitignore=38;5;240:*.gitmodules=38;5;240:*.lock=38;5;240:*.py=38;5;41:*.rb=38;5;160:*.go=38;5;81:*.rs=38;5;66:*.sh=38;5;76:*.fish=38;5;76:*.c=38;5;81:*.h=38;5;110:*.cpp=38;5;81:*.hpp=38;5;110:*.vim=38;5;34:*.lua=38;5;33:*.el=38;5;160:*.org=38;5;33:*.tpl=38;5;66:Makefile=38;5;81:makefile=38;5;81:*.mk=38;5;81"

set -x LS_COLORS "rs=0:di=1;38;5;75:ln=38;5;117:mh=00:pi=38;5;26:so=38;5;26:do=38;5;26:bd=38;5;68:cd=38;5;68:or=38;5;196:mi=38;5;196:su=38;5;196:sg=38;5;196:ca=38;5;196:tw=38;5;75:ow=38;5;75:st=38;5;75:fi=38;5;24:ex=38;5;34:*.tar=38;5;208:*.tgz=38;5;208:*.arc=38;5;208:*.arj=38;5;208:*.taz=38;5;208:*.lha=38;5;208:*.lz4=38;5;208:*.lzh=38;5;208:*.lzma=38;5;208:*.tlz=38;5;208:*.txz=38;5;208:*.tzo=38;5;208:*.t7z=38;5;208:*.zip=38;5;208:*.z=38;5;208:*.dz=38;5;208:*.gz=38;5;208:*.lrz=38;5;208:*.lz=38;5;208:*.lzo=38;5;208:*.xz=38;5;208:*.zst=38;5;208:*.tzst=38;5;208:*.bz2=38;5;208:*.bz=38;5;208:*.tbz=38;5;208:*.tbz2=38;5;208:*.tz=38;5;208:*.deb=38;5;208:*.rpm=38;5;208:*.jar=38;5;208:*.war=38;5;208:*.ear=38;5;208:*.sar=38;5;208:*.rar=38;5;208:*.alz=38;5;208:*.ace=38;5;208:*.zoo=38;5;208:*.cpio=38;5;208:*.7z=38;5;208:*.rz=38;5;208:*.cab=38;5;208:*.wim=38;5;208:*.swm=38;5;208:*.dwm=38;5;208:*.esd=38;5;208:*.jpg=38;5;133:*.jpeg=38;5;133:*.mjpg=38;5;133:*.mjpeg=38;5;133:*.gif=38;5;133:*.bmp=38;5;133:*.pbm=38;5;133:*.pgm=38;5;133:*.ppm=38;5;133:*.tga=38;5;133:*.xbm=38;5;133:*.xpm=38;5;133:*.tif=38;5;133:*.tiff=38;5;133:*.png=38;5;133:*.svg=38;5;133:*.svgz=38;5;133:*.mng=38;5;133:*.pcx=38;5;133:*.mov=38;5;133:*.mpg=38;5;133:*.mpeg=38;5;133:*.m2v=38;5;133:*.mkv=38;5;133:*.webm=38;5;133:*.webp=38;5;133:*.ogm=38;5;133:*.mp4=38;5;133:*.m4v=38;5;133:*.mp4v=38;5;133:*.vob=38;5;133:*.qt=38;5;133:*.nuv=38;5;133:*.wmv=38;5;133:*.asf=38;5;133:*.rm=38;5;133:*.rmvb=38;5;133:*.flc=38;5;133:*.avi=38;5;133:*.fli=38;5;133:*.flv=38;5;133:*.gl=38;5;133:*.dl=38;5;133:*.xcf=38;5;133:*.xwd=38;5;133:*.yuv=38;5;133:*.cgm=38;5;133:*.emf=38;5;133:*.ogv=38;5;133:*.ogx=38;5;133:*.aac=38;5;99:*.au=38;5;99:*.flac=38;5;99:*.m4a=38;5;99:*.mid=38;5;99:*.midi=38;5;99:*.mka=38;5;99:*.mp3=38;5;99:*.mpc=38;5;99:*.ogg=38;5;99:*.ra=38;5;99:*.wav=38;5;99:*.oga=38;5;99:*.opus=38;5;99:*.spx=38;5;99:*.xspf=38;5;99:*.md=38;5;33:*.txt=38;5;24:*.nix=38;5;25:*.html=38;5;208:*.css=38;5;39:*.js=38;5;25:*.ts=38;5;26:*.json=38;5;67:*.yaml=38;5;29:*.yml=38;5;29:*.toml=38;5;66:*.ini=38;5;66:*.git=38;5;197:*.gitignore=38;5;240:*.gitmodules=38;5;240:*.lock=38;5;240:*.py=38;5;41:*.rb=38;5;160:*.go=38;5;81:*.rs=38;5;66:*.sh=38;5;76:*.fish=38;5;76:*.c=38;5;81:*.h=38;5;110:*.cpp=38;5;81:*.hpp=38;5;110:*.vim=38;5;34:*.lua=38;5;33"

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
set -x DIRENV_LOG_FORMAT ""
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
if type -q scw
  complete --erase --command scw
  complete --command scw --no-files
  complete --command scw --arguments '(scw autocomplete complete fish -- (commandline) (commandline --cursor) (commandline --current-token) (commandline --current-process --tokenize --cut-at-cursor))'
end

if status is-interactive
    if set -q SSH_CLIENT || set -q SSH_TTY
        set -x TERM xterm-256color
    end
end
