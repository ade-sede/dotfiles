{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Programming Languages & Compilers
    # Some staples, always good to have them on the system
    bun
    gcc
    go
    nodejs_22
    python311

    # Development Tools & Linters
    alejandra
    devbox
    direnv
    docker-client
    docker-compose
    gitleaks
    gnumake
    mdformat
    nix-prefetch-git
    nix-tree
    pre-commit
    shellcheck
    stylua

    # File Management
    coreutils
    eza
    fd
    file
    rsync
    stow
    tree
    unzip
    zip

    # System Monitoring
    btop
    htop
    iftop
    lsof
    watch

    # Networking
    curl
    dig
    expect
    netcat
    nmap
    wget

    # Text Processing
    bat
    delta
    jq
    ripgrep
    silver-searcher

    # Other
    asciinema
    bc
    fzf
    gh
    git
    gnupg
    killall
    lazygit
    man-pages
    scaleway-cli
    tig
    tmux

    # Editors
    emacs
    vim
    (pkgs.writeShellScriptBin "nvim" ''
      export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
      export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)

      exec ${pkgs.neovim}/bin/nvim "$@"
    '')

    # Fonts
    jetbrains-mono

    # LLM Agents CLI
    (pkgs.writeShellScriptBin "claude" ''
      exec "${pkgs.nodePackages.npm}/bin/npx" @anthropic-ai/claude-code "$@"
    '')
    (pkgs.writeShellScriptBin "gemini" ''
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)
      exec "${pkgs.nodePackages.npm}/bin/npx" @google/gemini-cli "$@"
    '')
    (pkgs.writeShellScriptBin "opencode" ''
      export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
      export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
      export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)

      exec "${pkgs.nodePackages.npm}/bin/npx" opencode-ai@latest "$@"
    '')

    # Custom Scripts & Wrappers
    (pkgs.buildGoModule rec {
      pname = "osc";
      version = "0.4.8";
      src = pkgs.fetchFromGitHub {
        owner = "theimpostor";
        repo = "osc";
        rev = "v''${version}";
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
    (pkgs.writeShellScriptBin "gis" ''
      exec ''${pkgs.git-spice}/bin/gs "$@"
    '')
  ];
}
