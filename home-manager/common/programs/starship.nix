# Starship prompt config — format, colors from the active palette, and a custom SSH/devbox/GPG context tree segment.
{
  config,
  pkgs,
  theme,
  ...
}: let
  hexToRgb = hex: let
    r = builtins.substring 1 2 hex;
    g = builtins.substring 3 2 hex;
    b = builtins.substring 5 2 hex;
    toInt = h: (builtins.fromTOML "v=0x${h}").v;
  in "${toString (toInt r)};${toString (toInt g)};${toString (toInt b)}";
in {
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
        when = ''[ -n "$SSH_CONNECTION" ] || [ -n "$DEVBOX_WD" ] || [ -f "$HOME/.gnupg/pubring.kbx" ]'';
        shell = ["sh"];
        command = ''
          n=0
          [ -n "$SSH_CONNECTION" ] && n=$((n+1))
          [ -n "$DEVBOX_WD" ] && n=$((n+1))
          [ -f "$HOME/.gnupg/pubring.kbx" ] && n=$((n+1))
          i=0
          if [ -n "$SSH_CONNECTION" ]; then
            i=$((i+1)); [ $i -lt $n ] && c="├─" || c="└─"
            printf "%s  \360\237\214\220 \033[1;38;2;255;121;198m%s\033[0m" "$c" "$HOSTNAME"
            [ $i -lt $n ] && printf "\n"
          fi
          if [ -n "$DEVBOX_WD" ]; then
            i=$((i+1)); [ $i -lt $n ] && c="├─" || c="└─"
            printf "%s  \360\237\222\273 \033[1;38;2;224;165;104mdevbox shell\033[0m" "$c"
            [ $i -lt $n ] && printf "\n"
          fi
          if [ -f "$HOME/.gnupg/pubring.kbx" ]; then
            i=$((i+1)); [ $i -lt $n ] && c="├─" || c="└─"
            if gpg-connect-agent 'KEYINFO --list' /bye 2>/dev/null | awk '/^S KEYINFO/ && $8=="P" && $7=="1"{f=1} END{exit !f}'; then
              printf "%s  \360\237\224\223 \033[1;38;2;${hexToRgb theme.green}mgpg unlocked\033[0m" "$c"
            else
              printf "%s  \360\237\224\222 \033[1;38;2;${hexToRgb theme.red}mgpg locked\033[0m" "$c"
            fi
            [ $i -lt $n ] && printf "\n"
          fi
          exit 0
        '';
        format = "\n$output";
      };
    };
  };
}
