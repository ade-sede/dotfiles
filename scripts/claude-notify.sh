#!/usr/bin/env bash

INPUT=$(cat)

if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd')
PERMISSION_MODE=$(echo "$INPUT" | jq -r '.permission_mode')
PROJECT=$(basename "$CWD")
SESSION=$(tmux display-message -p '#S' 2>/dev/null || echo "")

MSG="Claude done · ${PROJECT}"
[ -n "$SESSION" ] && MSG="${MSG} · ${SESSION}"
[ "$PERMISSION_MODE" != "default" ] && MSG="${MSG} · ${PERMISSION_MODE}"

printf '\e]9;%s\e\\' "$MSG"
