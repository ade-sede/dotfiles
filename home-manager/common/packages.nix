{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "gis" ''
      exec ${pkgs.git-spice}/bin/gs "$@"
    '')
    dig
    iputils
    scaleway-cli
    bc
    jetbrains-mono
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
    bun
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
    gitleaks
    mdformat
    emacs
    nushell
    (pkgs.writeShellScriptBin "claude" ''
      exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
    '')
    (pkgs.writeShellScriptBin "codex" ''
      export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
      export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)

      exec ${pkgs.nodePackages.npm}/bin/npx @openai/codex "$@"
    '')
    (pkgs.writeShellScriptBin "opencode" ''
      export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
      export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)

      exec ${pkgs.nodePackages.npm}/bin/npx opencode-ai@latest "$@"
    '')
    (pkgs.writeShellScriptBin "nvim" ''
      export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
      export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)

      exec ${pkgs.neovim}/bin/nvim "$@"
    '')
    (pkgs.buildGoModule rec {
      pname = "osc";
      version = "0.4.8";
      src = pkgs.fetchFromGitHub {
        owner = "theimpostor";
        repo = "osc";
        rev = "v${version}";
        sha256 = "sha256-XVFNcQH4MFZKmuOD9b3t320/hE+s+3igjlyHBWGKr0Q=";
      };
      vendorHash = "sha256-k+4m9y7oAZqTr8S0zldJk5FeI3+/nN9RggKIfiyxzDI=";
      meta = with pkgs.lib; {
        description = "Access the system clipboard from anywhere using the ANSI OSC52 sequence";
        homepage = "https://github.com/theimpostor/osc";
        license = licenses.mit;
        maintainers = [];
      };
    })
  ];
}
