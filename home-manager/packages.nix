{
  pkgs,
  lib,
  ...
}: let
  secrets = import ./secrets.nix {inherit pkgs lib;};
  geminiKey = secrets.apiKeys.geminiKey;
  claudeKey = secrets.apiKeys.claudeKey;
  openaiKey = secrets.apiKeys.openaiKey;
in {
  home.packages = with pkgs; [
    alejandra
    asciinema
    bat
    btop
    coreutils
    curl
    delta
    devbox
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
      export FAKE_LITELLM_KEY="sk-litellm-proxy-fake-key"
      exec ${pkgs.nodePackages.npm}/bin/npx @openai/codex "$@"
    '')
  ];
}
