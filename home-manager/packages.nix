{
  pkgs,
  lib,
  config,
  ...
}: let
  secrets = import ./secrets.nix {inherit pkgs lib config;};
in {
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
    llvm
    lsof
    man-pages
    netcat
    nix-prefetch-git
    nmap
    nodejs_22
    pinentry
    pre-commit
    python311
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
      export ANTHROPIC_API_KEY="${secrets.apiKeys.claudeKey}"
      export OPENAI_API_KEY="${secrets.apiKeys.openaiKey}"
      export GEMINI_API_KEY="${secrets.apiKeys.geminiKey}"
      export LITELLM_API_KEY=key="sk-litellm-proxy-fake-key"

      exec ${pkgs.nodePackages.npm}/bin/npx @openai/codex "$@"
    '')
  ];
}
