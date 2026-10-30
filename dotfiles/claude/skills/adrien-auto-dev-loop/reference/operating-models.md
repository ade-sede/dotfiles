# Operating models

There are four operating models: sequential, single worktree
parallelisation, feature swarm and surface swarm.

By default and unless the task says otherwise, assume sequential. The plan
has an "Operating model" section where the planning agent can propose
another model when it fits the task better. Ultimately, the user chooses
when they validate the plan.

Each model below says when to use it, how it runs, and its git sequence.
The branch and commit rules that hold in every model are in
`~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/SKILL.md`.

## Sequential

Every PR happens inside a single worktree, and agents work one after the
other, as if they were sitting in front of the computer one by one.

Git: one worktree, PR n is created on top of PR n-1 once PR n-1 is pushed.
No restack is ever needed except by `loop-ci-fixer`.

## Single worktree parallelisation

Every PR happens inside a single worktree, but several implementers work
at the same time. You become responsible for keeping their diffs apart,
so this model only applies when the changes don't risk conflicting.

Git: one branch, several `loop-implementer` at once, each with an explicit
list of files it may touch in its prompt, each committing only those
files. When they are all done you run `gis branch split` to turn each
commit into its own branch, in plan order, and the pipeline continues per
branch from the reviews onward.

## The two swarms

A swarm is several agents working at the same time, each in its own
worktree, on items that don't depend on each other. Both swarms start
with one PR built through the normal pipeline, because that PR is what
the others build on.

They differ in what an item is.

|              | Feature swarm                                                        | Surface swarm                                                                     |
|--------------|----------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| What for     | one feature cut into slices                                          | one recipe applied to many places                                                 |
| First PR     | the contract: types, interfaces, in-memory implementations, simulators, factories, the migration | the reference: the recipe applied once                |
| An item      | a slice: repository, business rule, endpoint, job, each different    | a place the recipe applies to, all alike                                          |
| Items per PR | 1                                                                    | up to 10, or 300 changed lines                                                    |
| Who works    | `loop-implementer`, one per slice, 2 or 3 at a time                  | `loop-swarm-worker`, 2 of them by default, 3 at most, claiming items on their own |
| Last PR      | the wiring: connects the slices, holds the end-to-end test           | none                                                                              |
| Final shape  | a stack: contract, slices in plan order, wiring                      | siblings on the reference PR, merge in any order                                  |

### Feature swarm

Use it when the planning agent can write a contract that the slices code
against, and when every slice can be tested against the contract's
in-memory implementations without the other slices. That is what the
`adrien-test-style` skill asks for anyway, so a feature that follows it is
a feature that can be swarmed.

Don't use it when slices change the same files, when the design is not
settled enough to write the contract first, when there are fewer than 2
slices, or when a slice is under 30 minutes of work: the contract PR and
the wiring PR cost about 2 hours together, so below that the swarm saves
nothing over sequential mode.

A run holds the contract and up to 3 slices, or the slices and the wiring.
With more than 3 slices, the plan splits the feature into two runs at that
line, and the slices of run 1 are linearised and pushed before run 1 ends.

How it runs:

1. The plan has a "Contract" section, a "Slices" section with one
   subsection per slice (what it delivers, which files, its test
   scenarios), and a "Wiring" section.
2. The contract PR goes through the normal pipeline in the main worktree.
   The swarm starts once it is pushed.
3. You create one worktree and one branch per slice, based on the contract
   branch, write one brief per slice, and spawn one `loop-implementer` per
   slice. The normal pipeline runs per slice: 3 reviews, arbiter,
   integrate, docstrings. 2 or 3 slices at a time.
4. When a slice's docstring agent has committed, you remove its worktree.
   Slices are not pushed yet.
5. When every slice is done, you linearise them into a stack in plan order
   from the main worktree: `gis branch onto` moves slice 2 onto slice 1,
   slice 3 onto slice 2, and so on. Slices don't share files, so this
   rebases without conflicts. Then you push the stack with
   `gis stack submit --draft` and edit each PR body from its
   `pr-description.md`.
6. The wiring PR is created on top of the last slice and goes through the
   normal pipeline in the main worktree, like a sequential PR. The
   end-to-end test lives there.

Git: `loop-ci-fixer` always works in the main worktree, where every branch
is restackable, because git-spice can't restack a branch that is checked
out in another worktree.

### Surface swarm

Use it when the plan is one recipe applied many times. The planning agent
proposes it when it can write the recipe as one worked example and list
the places it applies to as items that don't depend on each other.

Don't use it when items must happen in order, when an item changes the
schema, or when most items need the database to be tested: the lock lets
one test run through at a time, so a swarm waiting on the lock is a
sequential loop with more agents.

How it runs:

1. The plan has a "Recipe" section and a "Queue" section. The queue is a
   list of items, each with a name and the files it touches.
2. The first item becomes the reference PR. It goes through the normal
   pipeline. The swarm starts only once that PR is open, because its code
   is what the workers copy.
3. You create the queue folders, one file per remaining item, then N
   worktrees, each with its own branch off the reference branch, and spawn
   one `loop-swarm-worker` per worktree. A run takes at most 30 items;
   when the plan lists more, it says which items belong to this run, and
   the retro says where the queue stopped.
4. A worker claims an item by moving its file from
   `~/.agent-loop/<task>/queue/todo/` to
   `~/.agent-loop/<task>/queue/<worker>/`, does the work, commits once
   with the item's name as the title, moves the file to
   `~/.agent-loop/<task>/queue/done/`, and claims the next one. Moving a
   file is atomic, so two workers can't claim the same item and you are
   not in the loop for every claim.
5. A branch is full when it holds 10 items or 300 changed lines, or when
   the queue is empty. The worker stops and reports. You run the normal
   pipeline on that branch (3 reviews, arbiter, integrate, docstrings,
   PR), remove the worktree, and if items remain, create a fresh worktree
   and branch and spawn a fresh worker.
6. The run ends when `queue/todo/` and every `queue/<worker>/` folder is
   empty, or the run's items are done, and every branch is pushed.

Git: one worktree and one branch per `loop-swarm-worker`, based on the
reference branch, one commit per item. When a branch is full, the
pipeline runs in that worktree, you push with
`gis branch submit --draft --fill`, you remove the worktree, and a fresh
worker gets a fresh branch. The branches stay siblings: nothing is
linearised.

### What both swarms share

- DB lock: unchanged. An agent asks before a DB test run and releases the
  lock after. The preconditions above are what keep the lock quiet.
- Status views: the agent view shows one row per running worktree. In a
  surface swarm the scope column reads "Swarm: 4 items done, item 12 in
  progress", from `ls` on the queue folders, not from the workers. Formats
  are in
  `~/.dotfiles/dotfiles/claude/skills/adrien-auto-dev-loop/reference/status-views.md`.
- Reviews: unchanged, one round per PR. The arbiter knows the first PR is
  the accepted shape and rejects findings that argue with it.
- Retro: add one line per worktree you removed and one per linearisation
  conflict, if any.
