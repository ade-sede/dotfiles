---
name: adrien-update-dev-loop
description: >
  Edit the adrien-auto-dev-loop after it was split into skills, agent
  definitions and reference files: find the right piece for a change, apply
  it, update every pointer, run the link checks. Also reads retros of past
  runs to propose edits. User-invoked only.
disable-model-invocation: true
argument-hint: "[change in plain words | retro [task id]]"
---

# Update the dev loop

The loop is split into pieces on purpose, so that an agent in a normal
session can load one best practice without loading the loop. The cost is
that one change often touches several pieces. This skill carries the map
and the rules, so the user only has to say what they want.

## The map

| Topic                                                       | Piece                                                                                   |
|-------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| how code is written                                         | the `adrien-coding-style` skill                                                         |
| how tests are written                                       | the `adrien-test-style` skill                                                           |
| finding format, the 3 review lenses, what a nitpick is      | the `adrien-review` skill                                                               |
| docstrings, annotations, PR descriptions                    | the `adrien-docstrings` skill                                                           |
| plan shape and plan prose                                   | the `adrien-plan-style` skill                                                           |
| prose rules for everything                                  | `~/.dotfiles/dotfiles/docs/writing-style.md`                                            |
| words to use and words to avoid                             | `~/.dotfiles/dotfiles/docs/glossary.md`                                                 |
| code the user liked and disliked, with the reasons          | `~/.dotfiles/dotfiles/docs/patterns.md`                                                 |
| how a preference gets recorded                              | the `adrien-record-preference` skill                                                    |
| global rules: no comments, gis, draft PRs, commit messages  | `~/.dotfiles/dotfiles/claude/CLAUDE.md`                                                 |
| runs, roles, order, briefing, git model, cadences, autonomy | `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/SKILL.md`                      |
| operating models                                            | `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/operating-models.md` |
| status tables                                               | `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/status-views.md`     |
| handoff folder, brief, queue, retro, Linear headers         | `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/handoff.md`          |
| one role: model, tools, preloaded skills, loop-only rules   | `~/.dotfiles/dotfiles/claude/agents/loop-<role>.md`                                     |

When you add a piece, add its row here.

## The cut rule

Before editing, decide where the change belongs with three questions,
in this order:

1. Is it true for a lone agent in a normal session, with no loop around
   it? Then it goes in a best-practice skill. That skill must never name
   the orchestrator, the arbiter, the handoff folder, the lock or the loop.
2. Is it only true inside the loop, for one role? Then it goes in that
   role's file under `~/.dotfiles/dotfiles/claude/agents/`.
3. Is it about the orchestrator's own job? Then it goes in
   `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/SKILL.md`, or
   in one of its reference files when the orchestrator needs it only at
   one moment of the loop.

One change can land in two places: the rule in a skill, and a one-line
override or pointer in an agent body. That is fine. The same sentence in
two places is not: write it once and point to it.

## Two rules every edit keeps

The spine: every example in every piece uses the same duplicate-claims
feature, `flag_duplicate_claims`. A new example is about that feature too.
Don't fix the bad examples, they are bad on purpose.

The linking rule: a skill is named by its exact name ("load the
`adrien-coding-style` skill"), a file by its full path under
`~/.dotfiles`. No relative path, no `~/.claude/` or `~/.config/` symlink
path, no "the coding style doc".

## Change mode

Given a request like "the arbiter is too lenient on naming":

1. Find every piece that touches the topic with the map and a grep across
   `~/.dotfiles/dotfiles/claude/skills/adrien-*/` and
   `~/.dotfiles/dotfiles/claude/agents/loop-*.md`.
2. Apply the cut rule and say, before editing, which piece gets the change
   and why. If the request is a question ("where is X?"), answer and stop.
3. Edit. Follow `~/.dotfiles/dotfiles/docs/writing-style.md`: full
   sentences linked by "when", "if", "so"; a bad/good pair with "What
   makes it bad/good" when the rule needs one.
4. Update every piece that points to what changed: a renamed skill, a moved
   section, a new file. The roster in the loop skill and the `skills` list
   in the agent frontmatter are the usual ones.
5. Run `~/.dotfiles/dotfiles/claude/skills/adrien-update-dev-loop/scripts/check-links.sh`
   and fix what it reports.
6. Show the diff with one line per file saying what changed and why.

## Retro mode

`retro` with no argument reads every `~/.agent-loop/*/retro.md`, because
one run leaves 2 to 6 PRs and that is too little to see a pattern.
`retro ENG-1234` reads the retros of one task only, all its runs. The
shape of a retro is in
`~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/handoff.md`.
Retro mode also reads `~/.dotfiles/dotfiles/docs/patterns.md` and
`~/.dotfiles/dotfiles/docs/glossary.md`.

Propose an arbiter guideline only when the same kind of decision shows up
in at least 3 PRs. Before that, list what you saw and say it is too early.

Look for patterns, not single events:
- the same kind of finding kept or rejected across several PRs: that is
  an arbiter guideline waiting to be written in the `adrien-review` skill
- the same `Unclear rule:` line from several agents: that rule is badly
  written, find it with the map and rewrite it
- the same CI failure fixed the same way twice: a rule for
  `~/.dotfiles/dotfiles/claude/agents/loop-ci-fixer.md`
- a user intervention mid-run: the strongest signal, the loop did
  something the user did not want; find which rule allowed it
- the same kind of disliked pattern recorded 3 times or more in
  `~/.dotfiles/dotfiles/docs/patterns.md`: propose a rule for the
  `adrien-coding-style` skill, citing the entries

For each pattern, propose one edit: the piece, the new text, and the retro
lines that justify it. Apply nothing until the user says yes, then continue
with change mode steps 4 to 6.
