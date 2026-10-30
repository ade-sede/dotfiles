#!/usr/bin/env bash
set -uo pipefail

dotfiles="$HOME/.dotfiles"
claude="$dotfiles/dotfiles/claude"

pieces=(
  "$claude"/skills/adrien-*/SKILL.md
  "$claude"/skills/adrien-auto-dev-loop/reference/*.md
  "$claude"/agents/loop-*.md
  "$dotfiles"/dotfiles/docs/glossary.md
  "$dotfiles"/dotfiles/docs/patterns.md
)

pieces_without_rules=()
for piece in "${pieces[@]}"; do
  [[ "$piece" == */adrien-update-dev-loop/* ]] || pieces_without_rules+=("$piece")
done

best_practices=(
  "$claude"/skills/adrien-coding-style/SKILL.md
  "$claude"/skills/adrien-test-style/SKILL.md
  "$claude"/skills/adrien-review/SKILL.md
  "$claude"/skills/adrien-docstrings/SKILL.md
  "$claude"/skills/adrien-plan-style/SKILL.md
  "$claude"/skills/adrien-record-preference/SKILL.md
  "$dotfiles"/dotfiles/docs/glossary.md
  "$dotfiles"/dotfiles/docs/patterns.md
)

failed=0

report() {
  echo "$1"
  failed=1
}

while IFS= read -r hit; do
  report "forbidden pointer: $hit"
done < <(grep -nH \
  -e '~/\.claude/' \
  -e '~/\.config/' \
  -e '](\./' \
  -e '](\.\./' \
  -e 'the coding style doc' \
  -e 'the style doc' \
  -e 'instructions apply to you' \
  "${pieces_without_rules[@]}")

while IFS= read -r hit; do
  report "loop word in a best-practice piece: $hit"
done < <(grep -nHiw -e orchestrator -e arbiter -e handoff -e lock -e loop "${best_practices[@]}")

while IFS= read -r name; do
  [[ -d "$claude/skills/$name" ]] || report "unknown skill: $name"
done < <(grep -ohE '\badrien-[a-z]+(-[a-z]+)*' "${pieces[@]}" | sort -u)

while IFS= read -r path; do
  [[ "$path" == *[\<\*]* ]] && continue
  [[ -e "${path/#\~/$HOME}" ]] || report "missing path: $path"
done < <(grep -ohE '~/\.dotfiles/[A-Za-z0-9_./<>*-]+' "${pieces[@]}" | sed 's/[.,:]*$//' | sort -u)

exit "$failed"
