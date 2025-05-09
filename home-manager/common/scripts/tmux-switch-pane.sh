#!/usr/bin/env bash

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#d0d0d0,bg:-1,hl:#5f87af --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff --color=marker:#87ff00,spinner:#af5fff,header:#87afaf'

MINIMAL_TMUX_CONFIG=$(mktemp)
echo "" > $MINIMAL_TMUX_CONFIG

LIST_DATA="#{session_name}"
FZF_COMMAND="fzf-tmux -p --delimiter=: --with-nth 4 --color=hl:2"

TARGET_SPEC="#{session_name}:#{window_id}:#{pane_id}:"

LINE=$(tmux -f $MINIMAL_TMUX_CONFIG list-sessions -F "$TARGET_SPEC $LIST_DATA" | $FZF_COMMAND) || exit 0
args=(${LINE//:/ })
tmux -f $MINIMAL_TMUX_CONFIG select-pane -t ${args[2]} && 
tmux -f $MINIMAL_TMUX_CONFIG select-window -t ${args[1]} && 
tmux -f $MINIMAL_TMUX_CONFIG switch-client -t ${args[0]}

rm $MINIMAL_TMUX_CONFIG