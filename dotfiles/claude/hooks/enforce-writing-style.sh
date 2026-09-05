#!/bin/bash
# PostToolUse hook: nudge to check prose against the personal writing style.
# Global hook, lives in dotfiles/claude/hooks and applies to every project.

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // ""')

PERSONAL_STYLE="$HOME/.claude/writing-style.md"
REPO_STYLE="${CLAUDE_PROJECT_DIR:-}/docs/writing_style.md"

NUDGE="Prose written or edited. Check it against ${PERSONAL_STYLE} before finishing (plain words, short sentences, no hedging, say why not what)."
if [[ -n "${CLAUDE_PROJECT_DIR:-}" && -f "$REPO_STYLE" ]]; then
  NUDGE="${NUDGE} Also check ${REPO_STYLE} for company conventions. On conflict, the personal style wins."
fi

nudge() {
  jq -n --arg ctx "$NUDGE" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: $ctx
    }
  }'
  exit 0
}

case "$TOOL" in
  Write|Edit)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
    case "$FILE_PATH" in
      *.md|*.txt|*.py|*.ts|*.tsx) nudge ;;
      *) exit 0 ;;
    esac
    ;;
  Bash)
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
    case "$COMMAND" in
      *gh\ pr\ create*|*gh\ pr\ edit*) nudge ;;
      *gis\ branch\ submit*|*gs\ branch\ submit*|*gis\ b\ s*|*gs\ b\ s*) nudge ;;
      *) exit 0 ;;
    esac
    ;;
  mcp__*)
    case "$TOOL" in
      *[Ll]inear*__save_*) nudge ;;
      *[Nn]otion*__notion-update-page*|*[Nn]otion*__notion-create-pages*) nudge ;;
      *) exit 0 ;;
    esac
    ;;
  *)
    exit 0
    ;;
esac

exit 0
