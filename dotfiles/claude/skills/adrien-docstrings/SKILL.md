---
name: adrien-docstrings
description: >
  Adrien's rules for the prose that ships with code: docstrings for
  functions and tests, annotations where code is likely to be misread, and
  PR descriptions. Load before writing or reviewing any of them in any
  session.
---

# Docstrings, annotations and PR descriptions

Read `~/.dotfiles/dotfiles/docs/writing-style.md` first: it says how to
write, this skill shows what a docstring is for.

This skill covers all the prose that ships with a change:
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

Annotate only where a reader is likely to misunderstand. Most code needs
none. The two kinds that earn their place, a reading hint above a predicate
and an outline of a flow, are shown in
`~/.dotfiles/dotfiles/docs/writing-style.md`.

The following is bad:

```python
# go through the claims
for claim in claims:
    # 30 days instead of 60, as requested in review
    window = timedelta(days=30)
```

What makes it bad:
- the first annotation narrates the next line
- the second one is change history, and it leaks the context of the session that wrote it: it belongs in the PR description

### PR description

Same spirit as the plan:
- focus on intent: what the PR achieves and why
- no mechanical description of the diff, the reviewer can read it
- high level view: how data moves, which concepts change

In practice:
- follow the repo's PR template when there is one
- start from the plan or the ticket behind the PR, when there is one

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
