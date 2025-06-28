{
  config,
  pkgs,
  theme,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = ''        $username@$directory$git_branch''${custom.context_tree}
        $character'';

      cmd_duration.disabled = true;
      package.disabled = true;

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold ${theme.cyan}";
      };

      directory = {
        format = "[$path]($style) [$read_only]($read_only_style)";
        style = "bold ${theme.green}";
      };

      character = {
        error_symbol = "[❯](bold ${theme.red})";
        success_symbol = "[❯](bold ${theme.green})";
        vimcmd_symbol = "[VIM](bold green)";
      };

      git_branch = {
        style = "bold ${theme.purple}";
      };

      git_status = {
        style = "bold ${theme.red}";
      };

      custom.context_tree = {
        when = ''[ -n "$SSH_CONNECTION" ] || [ -n "$DEVBOX_WD" ]'';
        shell = ["sh"];
        command = ''if [ -n "$SSH_CONNECTION" ] && [ -n "$DEVBOX_WD" ]; then printf "├─   \033[1;38;2;255;121;198m%s\033[0m\n└─   \033[1;38;2;224;165;104mdevbox shell\033[0m" "$HOSTNAME"; elif [ -n "$SSH_CONNECTION" ]; then printf "└─   \033[1;38;2;255;121;198m%s\033[0m" "$HOSTNAME"; else printf "└─    \033[1;38;2;224;165;104mdevbox shell\033[0m"; fi'';
        format = "\n$output";
      };
    };
  };
}
