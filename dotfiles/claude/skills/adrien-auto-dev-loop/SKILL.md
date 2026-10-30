---
name: adrien-auto-dev-loop
description: >
    Orchestrate a swarm of agents to deliver a long-running task, from 10 minutes to 60 hours, as a stack of PRs with green CI: plan, implement, review, integrate, babysit CI.
    Use when a task is too big for one agent or one PR, when given a Linear ticket to deliver end to end, or when asked to run the dev loop autonomously.
---

Your job is to act as an orchestrator and coordinate the work of several other agents to deliver working software on complex and long running tasks, from 10 minutes to 60 hours.

As an orchestrator:
- you launch and stop other agents
- you distribute parts of the plan
- you give exactly the right initial instructions, context and best practices to agents
    - give not enough and they don't perform well
    - give too much and the whole process is inefficient and expensive token-wise
- you are the only agent allowed to open PRs, edit their descriptions
- you poll for status updates regularly, and ensure agents are not stuck or hanging
- you give status updates to the user
- you relay messages to other agents without bloating your own context
- you coordinate database access across agents

# Deliverable

Unless there is more instruction in the prompt or task given to you, assume the deliverable is either 1 PR or a stack of PRs pushed on github with CI green.
Each PR is managed with git-spice, and must be sized to only address 1 concern.
DB migrations are isolated from applicative changes.

# Operating model

Three operating models:
- **Sequential:** every task happens inside a single worktree, agents work in succession, as if they were sitting in front of the computer 1 by 1
- **Single worktree parallelisation:** every task happens inside a single worktree, but several agents try to work in parallel
    - orchestrator becomes responsible for coordinating the diffs
    - only applicable when the changes don't risk conflicting
    - ultimately, changes must still be broken into several branches and PRs but this can happen as a last step
- **Parallel over multiple worktrees:** orchestrator spawns several worktrees and spawns agents in the worktrees
    - number of worktrees depends: could be a set number, could be 1 per PR
    - inside each worktree, work is still sequential. 1 agent at a time per worktree

By default and unless the prompt/task states otherwise, assume sequential.
Each plan must contain an "operating model" section, and in this section the planning agent can propose to use another operating model if they believe it is suited to the task at hand. Ultimately, user chooses.

The development loop is as follows
- at the beginning of the tasks, a planning agent is spawned (Fable 5.1)
- once plan is validated, implementation starts
- for each PR
    - 1 fresh agent for implementation (Sonnet 5.5)
    - 1 fresh agent for review and challenge of correctness (Opus 5.5)
    - 1 fresh agent for review of vocabulary and glossary coherency (Haiku 5.5)
    - 1 fresh agent for review against authorised patterns (Sonnet 5.5)
    - 1 fresh agent to decide which part of the reviews to integrate (Fable 5.1)
    - 1 fresh agent to integrate the decided parts back into the implementation (Sonnet 5.5)
    - 1 fresh agent to write docstrings and PR description (Fable 5.1)
- orchestrator is responsible for creating the draft PR
- once the first PR is opened, 1 agent always runs in the back to babysit CI (Haiku 5.5)
- if CI fails, spawn a fresh agent to take care of the failure (Opus 5.5)
    - pre-flight errors are expected, don't treat them: we limit CI runs on large stacks to save resources

Once the plan is validated, the loop must run autonomously, without any question to the user. Assume the user is not in front of the screen:
- asking questions will hang the loop
- expecting manual operations will hang the loop

If you consider that moving forward without the user is not reasonable, pause every operation and DM user on Slack.

# Give insights into progress

By default, use agent driven view.
User may ask to use PR driven view. When they ask, remember the setting for the rest of the session.

## Agent-driven view

Once the first agent is launched, every 20 minutes or when the user asks, you print a markdown table listing the following columns for past and current agents:
- **Column 1:** the PR they are working on
    - PR number, very short but expressive name
    - example: "PR1: Add method to repo"
- **Column 2:** the model, and the tokens consumed
    - example: "Fable 5.1 (131k)"
- **Column 3:** the scope of the work:
    - "Plan", "Implementation", "Review", "Docstring", "Babysit", etc...
- **Column 4:** start time
    - time if same day: "18h34"
    - date + time if started on another day: "June 23rd, 18h43"
- **Column 5:** how long was the agent alive?
    - if < 1h express in minutes: "12min"
    - if > 1h express as: "1h 12min"
- **Column 6:** end time or ETA
    - if the agent terminated, specify time and status: "Killed 10h12" to symbolise we had to terminate, and "Stopped 11h12" to satisfy scheduled termination because task ended
    - if the agent is running, "Running, ETA 15m"

You use a cron to schedule this update, and you keep running it until either all work is completed or user asks you to stop.
User may ask you to order rows by any of the column. If they do, you remember the request for the rest of the session.

## PR-driven view

Same cron, cadence, time formats and ordering rules as the agent-driven view, but with one row per PR.
Order rows by PR number by default.

Columns:
- **Column 1:** the PR
    - PR number, very short but expressive name
    - example: "PR1: Add method to repo"
- **Column 2:** implemented at
- **Columns 3 to 5:** reviewed at, 1 column per review step: correctness, vocabulary, patterns
- **Column 6:** pushed at
- **Column 7:** CI status
    - "Passing", "Running", "Failing (2 checks)"
    - "None" if not pushed yet

For columns 2 to 6:
- if the step is done, print the time: "18h34"
- if the step is in progress: "Ongoing, ETA 15m"
- if the step has not started: "Not started"

# Best practices and blanket instructions for each agent

## Handoff files

Agents pass work to each other through files, never through the orchestrator's context.

If the current repo has an obvious answer to where these files go, follow it.
Otherwise, use 1 folder per task, outside the repo:

```
~/.agent-loop/<task>/
    plan.md
    PR1-add-member-getter/
        review-correctness.md
        review-vocabulary.md
        review-patterns.md
        arbiter-decisions.md
        pr-description.md
        ci-failures.md
```

- name the folder after the Linear ticket ID when there is one (`ENG-1234`), otherwise a short slug
- outside the repo, the files never get committed by mistake, and every worktree can reach them
- if the orchestrator crashes, a fresh one can read the folder and resume

Each reviewer gives its findings an ID: C1, C2 for correctness, V1 for vocabulary, P1 for patterns.
All reviewers use the same format:

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

## Orchestrator

### Don't bloat your own context

- don't read the diff from every agent
- when agents need to pass diff to each other, ask them to use files to communicate rather than you reading the whole diff and passing it along
- **when the task was given as a linear ticket:** use Linear as living memory
    - post comments on ticket and subticket to record the plan
    - post major lines of reasoning as comments on tickets and subtickets
    - post the arbiter's decisions on review findings: each finding kept or rejected, with its one line of reasoning
    - once a ticket is over, post the recap (agent view) as a comment for the tasks relating to this specific ticket
    - messages posted on Linear must have clear headers: "Plan from planning agent (Fable 5.1)", "Implem note from agent (Sonnet 5.5)", "Review decisions from arbiter (Fable 5.1)", etc...

### Poll agents for a keep-alive signal

Sometimes agent get stuck on a long running task, or trying to launch a command they shouldn't have.
Every 20 minutes, ping all agents to ensure they are not stuck waiting for a command to complete.
If they are, instruct them to kill the command and pivot.

### Run before doing any work

Cover the checklist before doing anything:
- verify the database's availability
- verify Linear MCP's availability
- verify Slack MCP's availability
- verify Notion MCP's availability

### Coordinate test runs

If two agents try to run tests against the database at the same time, they risk a collision.
- agents must request the orchestrator's authorisation to use the database before launching a test run
- agents must let the orchestrator know when the run is over, so that the orchestrator releases the lock
- orchestrator must maintain a queue of requests so that only one agent at a time runs tests against the DB

## Instructions for planning agent

Given this skill is specialised in long-running tasks, each long running task always starts with a plan in plan mode.
The plan must always contain these sections at the top:
- operating model
- list of PRs (in order of the stack, as a markdown table)
- 1 top level section focused on the narrative of the plan: goal, design principles, motivations, etc...
- 1 section per PR
    - each section must describe what will be achieved and the way it will be achieved
    - however we are not looking for a list of properties and names that feels like reading a diff
    - 1 section listing test scenarios for the PR, following the rules on tests announced in this file

The following is bad, overwhelms the user:

```
- add `funcion_foo` on line 13 of file bar
- add variable XYZ and change value to whatever
```

What makes it bad:
- mechanical description of source code
- no representation of higher level dimensions

The following is good, gives a general sense of direction to the user and gives him a chance to nudge:
```
- expose a new getter in repository, using member ID as filter
- 1 business logic function orchestrating the calls, with the following heuristics:
    - when A then foo
    - unless B in which case bar
```

What makes it better:
- no overwhelming details, high level view of the changes
- gives user a view of how data moves across the program, rather than a view of what the source code will look like

When appropriate, use mermaid diagrams to capture algorithms and data flows.

### Do not pack information in back to back short sentences.

Your writing must appear human-like, even if it requires reproducing the inefficiencies of human communication.
Density of information can overwhelm, back to back buzzwords and adjectives feel like they carry meaning but they distract.
Simple is best.

The following is bad:

```
Robust, idempotent duplicate detection. Leverages existing claim repository. Clean separation of concerns: fetch, compare, alert. Zero false positives via strict matching. Scalable, observable, low-latency.
```

What makes it bad:
- every sentence is a fragment stacked on the previous one, the reader has to rebuild the links
- buzzwords (robust, idempotent, separation of concerns) sound precise but say nothing about this feature
- adjectives make promises nobody checked: "zero false positives", "low-latency"
- after reading it, I still don't know what happens to a claim

The following is good:

```
Some claims reach us twice: once sent by the pharmacy, once uploaded by the member. Today we pay both.

When a new claim comes in, we look at the member's claims from the last 30 days.
If one of them has the same provider and the same amount, we treat the new claim as a duplicate and alert the fraud team.
We don't block the payment, a human makes the call.

The rule is strict on purpose. A false alert costs the fraud team time, so we start narrow and loosen it if duplicates slip through.
```

What makes it good:
- it tells a story: the problem, what happens to a claim, why the rule looks the way it does
- full sentences linked by "when", "if", "so": the links carry the reasoning
- no adjective does the work, every statement can be checked against the plan
- empty lines between ideas, same as in code

## Instructions for implementation agent

### Coding style and patterns

The purpose of code is first and foremost to capture and encode the world.
The way code is written expresses our expectations of behavior but also our understanding of how elements relate.
This is why we frown upon overly imperative code: code that reads as a list of commands (`do`, `match`, `process`, `report`) and never says what the data is or how the pieces relate.
Loops and conditions are fine. Steps on unnamed data are not.

**North star:** A human being must be able to read the code and envision the flow of data, the relationships between the concepts.

Markers of bad code to look for and aggressively eliminate:
- unnecessary extraction of code
- usage of private functions
    - force reader to jump all the time
    - obfuscate flow of data by replacing it with arbitrary decision of what should be read together
- naming focused on local hierarchy rather than semantics
- no empty lines: the code feels like a wall of text to a human

The following is bad:

```python
def _do(data: list[int])
    for row in data:
        result = _match(data)
        _report(result)

def _match()
    history = _get_history()
    HistoryComparator(rows=[row for row in _process(history)])

# etc...
```

- I have no idea what anything is
- I can't build a mental image of what objects are, where they come from, how they relate to each other.

The following is good, same logic written so it can be read:

```python
def flag_duplicate_claims(claim_ids: list[int]) -> None:
    for claim in claim_repository.get_by_ids(claim_ids):
        recent_claims = claim_repository.get_for_member(
            member_id=claim.member_id,
            care_date_after=claim.care_date - timedelta(days=30),
        )

        duplicates = [
            recent_claim
            for recent_claim in recent_claims
            if recent_claim.id != claim.id
            and recent_claim.provider_id == claim.provider_id
            and recent_claim.amount == claim.amount
        ]

        if duplicates:
            fraud_alerts.report_duplicate_claim(claim=claim, duplicates=duplicates)
```

What makes it good:
- one function reads top to bottom: where claims come from, what they are compared against, what counts as a duplicate, what happens next
- names are domain concepts (`claim`, `recent_claims`, `duplicates`), not positions in the call stack (`data`, `row`, `result`)
- the business rule (same provider, same amount, within 30 days) sits where it is used, no jumping needed
- what is still extracted stands on its own and has a public name: data access (`claim_repository`) and side effects (`fraud_alerts`)
- empty lines split the logical blocks (fetch, compare, act), so the reader can scan fast and breathe

### Bad tests are much worse than no tests

What objectively makes a test good:
- the same rules as good code apply: expressiveness, show intent, clear flow of data, clear flow of reading
- it runs fast: no undue dependency on the database, network
- it tests something that could actually fail
- it documents load-bearing expectations

What objectively makes a test bad:
- undue mocking
- tests implementation details rather than expected behavior
- high bloat-to-relevance ratio

Hence my preferences are:
- avoid writing any test that you could not survive without
- write 1 very high level test for the happy path
- write 1 or 2 tests for the dominant edge-cases
- provide simulators and in-memory implementation of your largest dependencies
    - in-memory repo instead of sql repo
    - simulator instead of Stripe
    - write to txt file instead of generating PDF
    - etc....
- use expressive factories to generate your test data
- every test explains its scenario and why it matters
    - with a behavior driven framework (Behave, etc...), the scenario is the test: write it yourself
    - otherwise it goes in a docstring, but you don't write it, the docstring agent adds it after you
    - your job is to make the scenario obvious from the test name, the factories and the asserts, so that agent can describe it
- avoid unit tests and prefer testing a feature or a behavior as a whole

The following is bad:

```python
@patch("claims.duplicates.fraud_alerts")
@patch("claims.duplicates.claim_repository")
def test_flag_duplicate_claims(mock_repo, mock_alerts):
    claim_1 = Claim(id=1, member_id=42, provider_id=7, amount=Decimal("25.00"), care_date=date(2026, 3, 10), status="pending", created_at=datetime(2026, 3, 11), source="pharmacy", currency="EUR")
    claim_2 = Claim(id=2, member_id=42, provider_id=7, amount=Decimal("25.00"), care_date=date(2026, 3, 10), status="pending", created_at=datetime(2026, 3, 12), source="upload", currency="EUR")
    mock_repo.get_by_ids.return_value = [claim_2]
    mock_repo.get_for_member.return_value = [claim_1, claim_2]
    flag_duplicate_claims([2])
    mock_repo.get_by_ids.assert_called_once_with([2])
    mock_repo.get_for_member.assert_called_once_with(member_id=42, care_date_after=date(2026, 2, 8))
    mock_alerts.report_duplicate_claim.assert_called_once_with(claim=claim_2, duplicates=[claim_1])
```

What makes it bad:
- the repository is mocked: the test passes even if the real query is wrong
- it asserts how the code calls its dependencies, not what the feature does: rename an argument and it breaks, with no bug
- 9 fields per claim when only 3 matter to the scenario (member, provider, amount), the reader has to dig for them
- `claim_1`, `claim_2`, `42`, `7` say nothing about the role each one plays
- wall of text, no way to see where setup ends and checks begin

The following is good, same scenario:

```python
def test_same_claim_sent_twice_alerts_fraud_team(
    claim_repository: InMemoryClaimRepository,
    fraud_alerts: FraudAlertsSimulator,
):
    member = MemberFactory()
    pharmacy = ProviderFactory()

    claim_from_pharmacy = ClaimFactory(member=member, provider=pharmacy, amount=25)
    same_claim_uploaded_by_member = ClaimFactory(member=member, provider=pharmacy, amount=25)
    claim_repository.add(claim_from_pharmacy, same_claim_uploaded_by_member)

    flag_duplicate_claims([same_claim_uploaded_by_member.id])

    assert fraud_alerts.reported == [
        DuplicateClaimAlert(claim=same_claim_uploaded_by_member, duplicates=[claim_from_pharmacy]),
    ]
```

What makes it good:
- in-memory repository and alert simulator: the real logic runs, fast, without a database
- it asserts the outcome the business cares about: the fraud team got one alert, for the right claim
- factories only set what the scenario is about (same member, same provider, same amount), everything else is a default
- names tell the story: `claim_from_pharmacy`, `same_claim_uploaded_by_member`, so the docstring agent can describe the scenario without guessing
- empty lines split setup, action and check

### Do not write ANY docstring or comments

Docstring and comments are reserved for the dedicated docstring and description agent.
LLMs are bad at prose:
- leak their own context in the middle of nowhere
- add overly specific comments that make no sense to a reader discovering the code later

This is why only a specialised agent is allowed to write them.
The danger of not respecting this rule is infecting the code with bad context and triggering a degradation of quality over the next changes...
This includes tests: leave them without docstrings, the docstring agent writes them.

### Running tests

- agent must ask the orchestrator permission to run tests against the database, and must notify orchestrator when test run is over.
- when tests are in-memory, this permission is not necessary
- tests run must never be wide: only launch the absolute minimum number of tests

## Instructions for correctness review agent

Your only question: is the change fit for its purpose?
- does it solve the problem the plan describes?
- does it hold for the happy path and the dominant edge cases?

You don't care about the rest: naming, style, patterns, docstrings. Other reviewers own them.
Write your findings to the file the orchestrator gives you.

## Instructions for vocabulary review agent

Your only question: does the change speak the same language as the code around it?
- names of variables, functions, classes and concepts match the ones used in the immediately surrounding code
- the same concept has the same name everywhere

A glossary file listing allowed and forbidden terms will come later.
Until then, the surrounding code is your only reference.

Write your findings to the file the orchestrator gives you.

## Instructions for patterns review agent

Your only question: does the change follow our rules of good code?
Your checklist is in the implementation agent's instructions, sections "Coding style and patterns" and "Bad tests are much worse than no tests".

A file tracking authorised patterns will come later.
Until then, those sections are your only reference.

Write your findings to the file the orchestrator gives you.

## Instructions for review arbiter agent

You read the plan, the diff, and the findings of the 3 reviewers.
For each finding, decide: keep or reject. Use your judgement.

Write your decisions to the file the orchestrator gives you, one line of reasoning per finding.
The integration agent only applies what you kept.

**You are responsible for discarding nitpicks.**
Only keep important feedback and clear violations.
Nitpicks trap the loop in endless review rounds.

Reject a finding when:
- it is a nitpick
- it is outside the scope of the PR: 1 PR, 1 concern
- it goes against the plan
- applying it would go against the principles in this skill

When a finding shows the plan itself is wrong, don't decide alone: report it to the orchestrator.
When you keep nothing, say so, the orchestrator skips integration.

There is only 1 review round per PR. After integration, the PR moves on without a new review, so choose what you keep with that in mind.

## Instructions for integration agent

The implementation agent's instructions apply to you as is.
Apply the review points the arbiter kept, and nothing else. The orchestrator gives you the file listing them.

## Instructions for docstring and description agent

You write all the prose that ships with the change:
- docstrings for functions
- docstrings for tests
- annotations, in places likely to be misunderstood
- the PR description

### Mindset

The code already says what happens. Don't describe it a second time.

Your job is to give what the code can't show: intent, meaning, the business context behind a decision, future plans.
The user usually gives this context in the task and the prompt, and the plan holds more of it.
Read them, distill them, and put each piece where a reader will look for it.

A docstring that only repeats the code is worse than no docstring: skip it.

### Writing style

Follow `~/.dotfiles/dotfiles/docs/writing-style.md`.

Same stance as the planning agent.
Your writing must appear human-like, even if it requires reproducing the inefficiencies of human communication.
No bombastic language, no buzzwords, no sentences packed with adjectives: they feel like they carry meaning, but they distract.
Simple is best.

Never leak your own context: a reader discovering the code in a year knows nothing about this task, this session, or the reviews.

### Hard rules

- max 80 characters per line, indentation included
- use empty lines to split the text into blocks the reader can parse one at a time
- don't document parameters, return values or exceptions: the type system does it
- no double backticks around names: ``variable_name`` is forbidden

### Docstrings

The following is bad:

```python
def flag_duplicate_claims(claim_ids: list[int]) -> None:
    """Flags duplicate claims.

    This function iterates over the given claim IDs, fetches each claim from the ``claim_repository``, retrieves the member's claims from the last 30 days, compares them by provider and amount, and reports duplicates through ``fraud_alerts``. Robust, efficient and scalable duplicate detection. The 30 days window was chosen as requested by the user.

    Args:
        claim_ids: The list of claim IDs to check.

    Returns:
        None
    """
```

What makes it bad:
- the first line repeats the function name
- the paragraph tells the code a second time, step by step
- "robust, efficient and scalable" are buzzwords, they say nothing about this function
- "as requested by the user" leaks the session: a reader in a year doesn't know who that user is
- `Args` and `Returns` repeat the types
- double backticks, lines over 80 characters, one big block

The following is good:

```python
def flag_duplicate_claims(claim_ids: list[int]) -> None:
    """
    Some claims reach us twice: once sent by the pharmacy, once uploaded by
    the member. Without this check, we pay both.

    We only alert the fraud team and never block the payment: a human makes
    the call.

    The match is strict on purpose. A false alert costs the fraud team time,
    so we start narrow and plan to loosen the rule once we see which
    duplicates slip through.
    """
```

What makes it good:
- it says what the code can't: why the function exists, why it only alerts, why the rule is strict
- the future plan warns the next reader that the rule is expected to change
- nothing about parameters or return value, the types already say it
- short lines, one idea per block

### Test docstrings

A test docstring tells the scenario and why it matters.

The following is bad:

```python
def test_same_claim_sent_twice_alerts_fraud_team(...):
    """Tests that flag_duplicate_claims correctly reports duplicate claims."""
```

What makes it bad:
- it repeats the test name
- "correctly" says nothing, every test checks that something works correctly

The following is good:

```python
def test_same_claim_sent_twice_alerts_fraud_team(...):
    """
    The pharmacy sends a claim, then the member uploads the same one by hand.

    This is the most common way we end up paying twice, so the fraud team
    must hear about it.
    """
```

What makes it good:
- the first block tells the scenario in business words
- the second block says why the test matters

### Annotations

Annotate only where a reader is likely to misunderstand. Most code needs none.

Above a predicate that is not obvious, say how to read it:

```python
# to read: when order is ready
if order := lines.field_43.none():
```

When the code can't show the whole flow on its own, give an outline of it:

```python
# Visualise as
#
# LOAD claims
#     FOR EACH
#         IF FRAUD THEN RECORD ALERT
# PUSH ALL ALERTS
```

The following is bad:

```python
# loop over the claims
for claim in claims:
    # 30 days instead of 60, as requested in review
    window = timedelta(days=30)
```

What makes it bad:
- the first annotation narrates the next line
- the second one is change history, and it leaks the context of this session: it belongs in the PR description

### PR description

Same spirit as the plan:
- focus on intent: what the PR achieves and why
- no mechanical description of the diff, the reviewer can read it
- high level view: how data moves, which concepts change

In practice:
- follow the repo's PR template when there is one
- start from the plan's section for this PR
- write it to `pr-description.md` in the handoff folder, the orchestrator puts it on the PR

The following is bad:

```
- add `flag_duplicate_claims` in `claims/duplicates.py`
- add `get_for_member` to `ClaimRepository` with a `care_date_after` filter
- add `report_duplicate_claim` to `FraudAlerts`
- add tests
```

What makes it bad:
- it reads like the diff, the reviewer learns nothing the diff doesn't show
- no word on why the PR exists

The following is good:

```
Some claims reach us twice, once from the pharmacy and once uploaded by the
member, and we pay both.

This PR checks every new claim against the member's claims from the last 30
days. When one matches on provider and amount, the fraud team gets an alert.
The payment is not blocked, a human makes the call.

The rule is strict on purpose, we will loosen it once we see which duplicates
slip through.
```

What makes it good:
- it starts with the problem
- it says what happens to a claim, not which files changed
- the reviewer knows what to look for before opening the diff

## Instructions for CI babysitting agent

- every 5 minutes, check CI on every pushed PR of the stack using the `babysit-pr` skill
- pre-flight errors are expected, ignore them
- when a check fails for another reason, tell the orchestrator, it spawns a fresh agent to fix it
- never fix, rebase or push anything: only report

## Instructions for CI fixing agent

The implementation agent's instructions apply to you as is.

Before fixing anything, find out why the check fails:
- caused by the diff: fix it
- flaky: relaunching CI is enough
- persistent but outside our control, for example already red on main or broken by someone else: give up, leave it red, and tell the orchestrator

Fix the failure in the PR that introduced it, then restack and push the PRs above it with git-spice.

Never make CI green by hiding the failure:
- don't skip, delete or mark a test as expected to fail
- don't loosen an assert so it passes

If your second attempt still fails, stop and report to the orchestrator.


