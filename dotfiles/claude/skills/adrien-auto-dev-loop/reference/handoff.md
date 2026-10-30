# Handoff files

Agents pass work to each other through files, never through your context.

If the current repo has an obvious answer to where these files go, follow
it. Otherwise, use 1 folder per task, outside the repo:

```
~/.agent-loop/<task>/
    task.md
    plan.md
    retro.md
    queue/                      surface swarm only
        todo/
        <worker>/
        done/
    PR1-flag-duplicate-claims/
        brief.md
        review-correctness.md
        review-vocabulary.md
        review-patterns.md
        arbiter-decisions.md
        pr-description.md
        ci-failures.md
```

- name the folder after the Linear ticket ID when there is one
  (`ENG-1234`), otherwise a short slug
- outside the repo, the files never get committed by mistake, and every
  worktree can reach them
- if you crash, a fresh orchestrator reads the folder and resumes

## task.md

Before the planner starts, write the task exactly as the user gave it,
with the Linear ticket ID when there is one. The planner reads it to write
the plan, and the docstring agent reads it for the intent behind the code.

## plan.md

Written by `loop-planner`. Every PR section starts with a heading of the
form `## PR<n>: <name>`, so a brief can point an agent to its section by
that heading.

## brief.md

Written by you, once per PR, before its first agent starts. Every agent on
the PR reads it, so the facts are written once and your prompts stay
short:

```
task: ENG-1234
folder: ~/.agent-loop/ENG-1234/PR1-flag-duplicate-claims/
linear: ENG-1234
plan: ~/.agent-loop/ENG-1234/plan.md, read "Narrative" and "PR1: Flag duplicate claims"
branch: eng-1234-flag-duplicate-claims
base: main
worktree: /Users/ade-sede/code/backend
db tests: allowed, ask me first
```

When a fact changes (the base moved, the worktree was removed), update the
brief and tell the agents still running.

## Review findings and arbiter decisions

Each reviewer gives its findings an ID: C1, C2 for correctness, V1 for
vocabulary, P1 for patterns. The format is in the `adrien-review` skill:

```
## C1: duplicate check ignores the 30 days window
- where: claims/duplicates.py:14
- problem: ...
- suggestion: ...
```

The arbiter answers by ID, one line each:

```
- C1: kept, the plan says claims older than 30 days are never duplicates
- P2: rejected, outside the scope of the PR
```

## Queue, surface swarm only

One file per item in `queue/todo/`, named after the item, holding the
item's name and the files it touches. A worker claims an item by moving
its file to `queue/<worker>/` and moves it to `queue/done/` once
committed.

## retro.md

You write it as your last step of every run, then post it on Linear under
"Retro from orchestrator". The `adrien-update-dev-loop` skill reads it to
propose edits to the loop, and the next run reads its first lines to know
where to start, so keep the sections and one fact per line.

```
# Retro ENG-1234, run 2 of 3

operating model: surface swarm, 2 workers
PRs: 3, all green
duration: 3h 40min
next run starts at: item 19 of 30, PR4 wiring

## Arbiter decisions
- PR1 C1: kept, the plan says claims older than 30 days are never duplicates
- PR1 P2: rejected, outside the scope of the PR
- PR2 V1: rejected, nitpick: both names are used in the surrounding code

## CI failures
- PR2: flaky, relaunched
- PR3: caused by the diff, fixed in 1 commit

## Agents killed or stuck
- PR2 implementer: killed 16h02, waiting on a wide test run

## Unclear rules
- loop-implementer, PR1: "only the tests that cover your change" when the
  test module has one entry point for the whole feature
- loop-docstrings, PR3: the repo PR template asks for a "Testing" section
  and the skill says nothing about it

## User interventions
- 15h40: asked to stop PR2 and change the branch name
```

Agents feed the "Unclear rules" section: when a rule in their context was
unclear or fought the task, their final message carries one line starting
with `Unclear rule:`, and you copy it here.

## Linear headers

When the task comes from a Linear ticket, Linear is the living memory of
the task, and every message you post there starts with a clear header
naming its source:

- "Plan from planning agent (Fable 5.1)"
- "Implem note from agent (Sonnet 5.5)"
- "Review decisions from arbiter (Fable 5.1)"
- "Retro from orchestrator"
