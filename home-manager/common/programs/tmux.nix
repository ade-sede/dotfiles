{
  config,
  pkgs,
  theme,
  fishPath,
  ...
}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    historyLimit = 10000;
    baseIndex = 0;
    escapeTime = 0;
    terminal = "screen-256color";
    customPaneNavigationAndResize = true;
    shell = fishPath;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      yank
      prefix-highlight
      {
        plugin = tokyo-night-tmux;
        extraConfig = "set -g @tokyo-night-tmux_theme '${theme.tmux_theme}'";
      }
    ];
    extraConfig = ''
      set-option -g automatic-rename off
      bind-key s run-shell -b ~/.dotfiles/scripts/tmux-switch-pane.sh
      bind-key L switch-client -l
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-window-option -g monitor-activity off
      set-option -g bell-action none

      set -ag terminal-overrides ",*:RGB"
      set -g default-terminal "tmux-256color"

      # OSC52 clipboard support
      set -g allow-passthrough on
      set -g set-clipboard on

      set -g default-command "${fishPath}"
    '';
  };
}
