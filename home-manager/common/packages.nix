{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    go
    gnumake
    nix-tree
    alejandra
    asciinema
    bat
    btop
    coreutils
    curl
    delta
    devbox
    docker-client
    docker-compose
    eza
    fd
    file
    fzf
    gh
    git
    gnupg
    htop
    iftop
    jq
    killall
    lazygit
    gcc
    zig
    lsof
    man-pages
    netcat
    nix-prefetch-git
    nmap
    nodejs_22
    pre-commit
    python311
    pyright
    python311Packages.python-lsp-server
    python311Packages.ruff
    ripgrep
    rsync
    shellcheck
    silver-searcher
    stow
    tig
    tmux
    tree
    unzip
    vim
    watch
    wget
    zip
    (pkgs.writeShellScriptBin "claude" ''
      exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
    '')
    (pkgs.writeShellScriptBin "codex" ''
      export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
      export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)
      export LITELLM_API_KEY=key="sk-litellm-proxy-fake-key"

      exec ${pkgs.nodePackages.npm}/bin/npx @openai/codex "$@"
    '')
  ];
}
