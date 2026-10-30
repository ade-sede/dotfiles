---
name: adrien-review
description: >
  How Adrien wants a change reviewed: one lens at a time (correctness,
  vocabulary, patterns), findings in a fixed format with IDs, and no
  nitpicks. Load before reviewing a change in any session.
---

# Review

A review answers one question at a time. Mixing them gives a long list
where the finding that matters sits next to a nitpick, and the author can't
tell them apart. Use the lens you were asked for, or go through the three
in order when nobody said.

## Correctness

Your only question: is the change fit for its purpose?
- does it solve the problem the plan, the ticket or the PR description describes?
- does it hold for the happy path and the dominant edge cases?

You don't care about the rest: naming, style, patterns, docstrings. The
other lenses own them.

## Vocabulary

Your only question: does the change speak the same language as the code around it?
- names follow `~/.dotfiles/dotfiles/docs/glossary.md` first: a word listed under "don't use" is always a finding
- names of variables, functions, classes and concepts match the ones used in the immediately surrounding code
- the same concept has the same name everywhere

## Patterns

Your only question: does the change follow the rules of good code?

Your checklist is the `adrien-coding-style` skill, the `adrien-test-style`
skill, and the liked and disliked cases in
`~/.dotfiles/dotfiles/docs/patterns.md`. When the change repeats a disliked
case, quoting the entry is reason enough for the finding.

## What is not worth a finding

A nitpick is a finding that changes neither how a reader understands the
code nor whether it works: a synonym that the glossary and the surrounding
code both accept, a blank line, an import order the formatter doesn't
enforce, a taste that no rule and no recorded pattern backs. Nitpicks bury
the findings that matter, and each one costs the author a round trip.

Don't write a finding when:
- it is a nitpick
- it is outside the scope of the change: 1 PR, 1 concern
- it asks for something the plan or the ticket decided against

Keep only important feedback and clear violations of a rule.

## Finding format

Each finding gets an ID made of the lens letter and a number: C1, C2 for
correctness, V1 for vocabulary, P1 for patterns. The ID lets whoever reads
the findings answer each one by name.

```
## C1: duplicate check ignores the 30 days window
- where: claims/duplicates.py:14
- problem: ...
- suggestion: ...
```
