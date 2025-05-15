{
  config,
  pkgs,
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
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      yank
      prefix-highlight
      {
        plugin = tokyo-night-tmux;
        extraConfig = "set -g @tokyo-night-tmux_theme 'day'";
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

      if-shell "test -d ~/.alan" \
          "set -g default-shell '/Users/ade-sede/.nix-profile/bin/fish'" \
          "set -g default-shell '/etc/profiles/per-user/ade-sede/bin/fish'"
    '';
  };
}
