---
name: adrien-coding-style
description: >
  Adrien's rules for readable code: one function reads top to bottom, names
  are domain concepts, no private helpers, empty lines between blocks. Load
  before writing or reviewing code in any session.
---

# Coding style

Tests have their own rules: load the `adrien-test-style` skill for them.
Prose in and around code follows `~/.dotfiles/dotfiles/docs/writing-style.md`.
Names follow `~/.dotfiles/dotfiles/docs/glossary.md`.
Real code the user liked and disliked, with the reasons, is in
`~/.dotfiles/dotfiles/docs/patterns.md`. Read it before writing code: this
skill holds the rules, that file holds the cases behind them.

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
