{
  pkgs,
  lib,
  config,
  ...
}: let
  secrets = import ./secrets.nix {inherit pkgs lib config;};
  geminiKey = secrets.apiKeys.geminiKey;
  claudeKey = secrets.apiKeys.claudeKey;
  openaiKey = secrets.apiKeys.openaiKey;
in {
  home.packages = with pkgs; [
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
    iotop
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
    xclip
    zip
    (pkgs.writeShellScriptBin "claude" ''
      exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
    '')
    (pkgs.writeShellScriptBin "codex" ''
      export ANTHROPIC_API_KEY="${claudeKey}"
      export OPENAI_API_KEY="${openaiKey}"
      export GEMINI_API_KEY="${geminiKey}"
      export LITELLM_API_KEY=key="sk-litellm-proxy-fake-key"

      exec ${pkgs.nodePackages.npm}/bin/npx @openai/codex "$@"
    '')
  ];
}
