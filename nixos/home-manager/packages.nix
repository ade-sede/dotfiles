{
  config,
  pkgs,
  lib,
  ...
}: let
  secrets = import ../secrets.nix {inherit pkgs lib;};
  geminiKey = secrets.apiKeys.geminiKey;
  claudeKey = secrets.apiKeys.claudeKey;
  openaiKey = secrets.apiKeys.openaiKey;
in {
  home.packages = with pkgs; [
    fd
    unzip
    bash
    vim
    wget
    nodejs_22
    git
    tmux
    starship
    curl
    fzf
    python3
    python311Packages.pip
    python311Packages.mdformat
    eza
    github-cli
    bat
    coreutils
    gnugrep
    gawk
    findutils
    cmake
    gnumake
    gcc
    ripgrep
    docker
    docker-compose
    nixfmt-classic
    alejandra
    pre-commit
    go
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
