{
  config,
  pkgs,
  theme,
  ...
}: let
  atuinTheme = theme.atuin_theme;
in {
  home.file.".config/atuin/themes/shell.toml".text = ''
    Base = "${atuinTheme.Base}"
    Important = "${atuinTheme.Important}"
    AlertInfo = "${atuinTheme.AlertInfo}"
    AlertWarn = "${atuinTheme.AlertWarn}"
    AlertError = "${atuinTheme.AlertError}"
    Guidance = "${atuinTheme.Guidance}"
    Annotation = "${atuinTheme.Annotation}"
  '';

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      style = "compact";
      inline_height = 30;
      enter_accept = true;
      keymap_mode = "auto";
      show_help = false;
      show_tabs = false;
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "session";
      search_mode = "fuzzy";
      workspaces = true;
      secrets_filter = true;
      max_preview_height = 4;
      history_filter = ["^export "];
      theme.name = "shell";
      stats = {
        common_subcommands = [
          "cargo"
          "docker"
          "git"
          "go"
          "kubectl"
          "nix"
          "npm"
          "systemctl"
          "tmux"
        ];
        common_prefix = ["sudo"];
      };
      sync.records = true;
    };
  };
}
