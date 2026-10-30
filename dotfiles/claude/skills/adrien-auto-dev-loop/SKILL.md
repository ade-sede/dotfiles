---
name: adrien-auto-dev-loop
description: >
    Orchestrate a team of agents to deliver a task as a stack of PRs with green CI, in runs of 1 to 4 hours: plan, implement, review, integrate, babysit CI.
    A longer task is several runs on the same handoff folder.
    Use when a task is too big for one agent or one PR, when given a Linear ticket to deliver end to end, or when asked to run the dev loop autonomously.
---

Your job is to act as an orchestrator and coordinate the work of several other agents to deliver working software.

As an orchestrator:
- you launch and stop other agents
- you distribute parts of the plan
- you brief each agent with exactly what it needs, as described in "Briefing an agent"
- you create every branch and worktree, and you are the only agent allowed to open PRs and edit their descriptions
- you poll for status regularly, and make sure agents are not stuck or hanging
- you give status updates to the user
- you relay messages between agents without bloating your own context
- you coordinate database access across agents

# Runs

A run is one session of yours, 1 to 4 hours, and it ends with every PR it
started pushed and green. A task bigger than a run is several runs on the
same `~/.agent-loop/<task>/` folder. The plan says which PRs belong to
which run, and the retro of a run says where the next one starts. On a new
run, read the plan and the last retro before spawning anyone.

# Deliverable

Unless the task says otherwise, the deliverable is 1 PR or a stack of PRs pushed on GitHub with CI green.
Each PR is managed with git-spice, and must be sized to only address 1 concern.
DB migrations are isolated from applicative changes.

# The loop

Every role is an agent definition in `~/.dotfiles/dotfiles/claude/agents/`.

| Step                                         | Agent                       | Model      |
|----------------------------------------------|-----------------------------|------------|
| plan the task                                | `loop-planner`              | Fable 5.1  |
| implement one PR                             | `loop-implementer`          | Sonnet 5.5 |
| review correctness                           | `loop-reviewer-correctness` | Opus 5.5   |
| review vocabulary                            | `loop-reviewer-vocabulary`  | Haiku 5.5  |
| review patterns                              | `loop-reviewer-patterns`    | Sonnet 5.5 |
| decide which findings to apply               | `loop-arbiter`              | Fable 5.1  |
| apply the kept findings                      | `loop-integrator`           | Sonnet 5.5 |
| write docstrings and the PR description      | `loop-docstrings`           | Fable 5.1  |
| watch CI, from the first PR opened           | `loop-ci-babysitter`        | Haiku 5.5  |
| fix a CI failure                             | `loop-ci-fixer`             | Opus 5.5   |
| work through a surface swarm queue           | `loop-swarm-worker`         | Sonnet 5.5 |

The order:
1. write `~/.agent-loop/<task>/task.md`, then spawn `loop-planner`
2. present the plan to the user in plan mode; once they validate it, the run starts
3. for each PR: implement, then the 3 reviews in parallel, then the arbiter, then integration (skipped when the arbiter keeps nothing), then docstrings
4. open the draft PR and tell `loop-ci-babysitter` its number
5. when the babysitter reports a failure, spawn a fresh `loop-ci-fixer`

There is only 1 review round per PR. Every agent is fresh: never reuse one for a second PR.

Only `loop-docstrings` writes docstrings and comments. LLMs are bad at
prose: they leak their own context in the middle of nowhere, and add
overly specific comments that make no sense to a reader discovering the
code later. Letting every agent write them infects the code with bad
context, and the quality degrades over the next changes.

The operating model decides how PRs run side by side: sequential (the
default), single worktree parallelisation, feature swarm or surface swarm.
Each is described, with its git sequence, in
`~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/operating-models.md`.

# Autonomy

Once the plan is validated, the run must go on without any question to the user. Assume the user is not in front of the screen:
- asking questions will hang the run
- expecting manual operations will hang the run

If you consider that moving forward without the user is not reasonable, pause every operation and DM the user on Slack.

# Briefing an agent

The agent definition pins the model, the tools, the loop rules of the
role, and preloads the best-practice skills the role needs. You never
repeat any of that in a prompt: when you spawn `loop-implementer`, it
already holds the `adrien-coding-style` skill and the `adrien-test-style`
skill, and it knows it must not write docstrings.

What the definition can't know is the task. You give it in two pieces.

**brief.md, written once per PR.** Before the first agent of a PR starts,
write `~/.agent-loop/<task>/<PR>/brief.md`. The template and the rest of
the folder layout are in
`~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/handoff.md`.
Every agent on the PR reads the same brief, so the facts are written once.
When a fact changes, update the brief and tell the agents still running.

**The delegation prompt, 3 to 6 lines.** It names the brief, the role's
inputs, and the one file the agent writes:

```
Brief: ~/.agent-loop/ENG-1234/PR1-flag-duplicate-claims/brief.md
Inputs: the diff of the branch against its base, plan.md
Output: ~/.agent-loop/ENG-1234/PR1-flag-duplicate-claims/review-correctness.md
Report to me with one line when the file is written.
```

Rules for the prompt:
- full paths, not content: never paste the plan, the diff, or another agent's file
- one output file per agent, with its full path, so the next agent knows where to look
- no best practice, no style rule, no "remember to": the definition and the preloaded skills carry them
- the implementation prompt adds the list of files the agent may touch when the operating model needs it

| Role               | Reads                                                     | Writes                                  |
|--------------------|-----------------------------------------------------------|-----------------------------------------|
| loop-planner       | task.md, the Linear ticket, the repo                      | plan.md                                 |
| loop-implementer   | brief, plan (narrative + its PR section)                  | code, tests, 1 commit                   |
| loop-reviewer-*    | brief, plan section, branch diff                          | review-<lens>.md                        |
| loop-arbiter       | brief, plan section, branch diff, the 3 review files      | arbiter-decisions.md                    |
| loop-integrator    | brief, arbiter-decisions.md, the review files it names    | code, tests, 1 commit                   |
| loop-docstrings    | brief, task.md, plan section, branch diff                 | docstrings, pr-description.md, 1 commit |
| loop-ci-babysitter | the list of open PR numbers                               | ci-failures.md, one report per failure  |
| loop-ci-fixer      | brief, ci-failures.md, the failing check's logs           | code, 1 commit, a push                  |
| loop-swarm-worker  | brief, the plan's recipe, the item file it claimed        | code, 1 commit per item                 |

What you read yourself: `arbiter-decisions.md` to post it on Linear,
`pr-description.md` to open the PR, and the final message of every agent,
from which you collect the `Unclear rule:` lines for the retro. Nothing
else: don't read the diffs.

# Branches and commits

You create every branch and every worktree. Agents only commit.

Before the first agent of a PR starts, from the worktree the PR will use:

```
gis branch create <branch> --no-commit
```

The current branch becomes the base, so check out the previous PR's branch
first (`gis branch checkout`) when the PR goes on top of it, or trunk when
it doesn't. Branch names: `<ticket>-<slug>`, lower case, same slug as the
PR folder in `~/.agent-loop/<task>/`.

When the PR needs its own worktree:

```
git worktree add -b <branch> <path> <base branch>
cd <path> && gis branch track --base <base branch>
```

Write the branch, the base and the worktree in the PR's `brief.md`.

Every agent that changes code commits once before it ends, with
`gis commit create`, staging only the files it changed. New commit every
time, never an amend: the commits show who did what and a pushed branch is
never rewritten. The normal shape of a PR is:

1. the implementer's commit: the change
2. the integrator's commit: the review findings the arbiter kept
3. the docstring agent's commit: docstrings and annotations
4. the CI fixer's commits, when there are any

Pre-commit hooks run on every commit, and `--no-verify` is forbidden. If
the repo's hook runs tests against the database, a commit counts as a test
run and needs the lock. Commit messages follow the "Commit Messages"
section of `~/.dotfiles/dotfiles/claude/CLAUDE.md`. The title says what
changed, never which agent did it: "Flag duplicate claims", not
"Implementation: duplicate claims".

You are the only agent that opens PRs. After the docstring agent's commit:

```
gis branch submit --draft --fill
gh pr edit <number> --body-file ~/.agent-loop/<task>/<PR>/pr-description.md
```

The plan says whether the `ai-generated` label applies, so add it here
without asking. Then tell `loop-ci-babysitter` the new PR number.

Nobody else pushes, with one exception: `loop-ci-fixer`, which restacks
and pushes the PRs above its fix. Rebasing on trunk is not a routine step:
`loop-ci-fixer` does it only when a failure comes from a stale base.

# Running tests against the database

If two agents run tests against the database at the same time, they risk
a collision. You hold a lock:
- agents ask your permission by message before a DB test run
- agents tell you when the run is over, and you release the lock
- you keep a queue of requests so that only one agent at a time runs tests against the DB

In-memory tests need no permission.

# Don't bloat your own context

- don't read the diff of any agent
- agents pass work to each other through files, never through you
- when the task comes from a Linear ticket, use Linear as living memory:
    - post the plan on the ticket and its subtickets
    - post major lines of reasoning as comments
    - post the arbiter's decisions on review findings, each finding kept or rejected with its one line of reasoning
    - post the retro at the end of every run
    - every message has a clear header, listed in `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/handoff.md`

# Cadences

- every 20 minutes, or when the user asks, print the status table. The
  agent view and the PR view are in
  `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/status-views.md`.
- every 20 minutes, ping every running agent to make sure it is not stuck
  waiting for a command to complete. If it is, tell it to kill the command
  and pivot.
- `loop-ci-babysitter` checks CI every 5 minutes on its own.

# Before doing any work

Cover this checklist before anything else:
- verify the database's availability
- verify Linear MCP's availability
- verify Slack MCP's availability
- verify Notion MCP's availability

# When the user reacts during a run

When the user corrects a word or reacts to a piece of code while a run is
going, load the `adrien-record-preference` skill and record it before you
act on it. The user is writing to you at that moment, so asking them why
is fine. The agents you spawn never record anything themselves.

# End of a run

When every PR of the run is pushed and CI is green, or when you stop for
good:

1. stop `loop-ci-babysitter`
2. print the final status table
3. write `~/.agent-loop/<task>/retro.md` with the template in
   `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/handoff.md`,
   from the arbiter decisions of every PR, the CI reports, the agents you
   killed, the `Unclear rule:` lines agents gave you, and every message the
   user sent while the run lasted
4. post the retro on Linear under "Retro from orchestrator"
5. tell the user the run is over and that
   `/adrien-update-dev-loop retro <task>` reads the retro
