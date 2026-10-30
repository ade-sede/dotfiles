---
name: adrien-plan-style
description: >
  Adrien's rules for implementation plans: a narrative first, one section
  per PR that shows how data moves rather than what the diff will look
  like, test scenarios per PR, and plain human prose. Load before writing
  or reviewing a plan in any session.
---

# Plan style

A plan always contains these sections at the top:
- list of PRs (in order of the stack, as a markdown table)
- 1 top level section focused on the narrative of the plan: goal, design principles, motivations, etc...
- 1 section per PR
    - each section must describe what will be achieved and the way it will be achieved
    - however we are not looking for a list of properties and names that feels like reading a diff
    - 1 section listing test scenarios for the PR, following the `adrien-test-style` skill

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

## Plan prose

Follow `~/.dotfiles/dotfiles/docs/writing-style.md`. A plan is read by a
human who has to say yes or nudge it, so it must read like a person
explaining, not like a list of claims.

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
