# Writing style

Prose style for comments, docstrings, PR descriptions, and docs.

Write like a person explaining something to a colleague. Human-like beats efficient: keep the small words and the links between ideas, even when it costs a few more words.

## Plain words

Plain everyday words: readers include non-native speakers and people outside the domain. Swap fancy phrasing:

| Instead of                           | Write                         |
|--------------------------------------|-------------------------------|
| lands as                             | shows up as                   |
| kicks in                             | starts, applies               |
| mirrors                              | is the same as, same shape as |
| untouched                            | not changed                   |
| leverages                            | uses                          |
| essentially, worth noting, flip side | (just say the thing)          |
| eyeball                              | check, look at                |
| delve                                | look into                     |

## Full sentences, not fragments

- Write full sentences and link them with "when", "if", "so", "because". The links carry the reasoning, so the reader doesn't have to rebuild it.
- Don't stack fragments. "Robust pipeline. Leverages the repo. Zero downtime." reads fast and says nothing.
- No buzzwords, no bombastic language, no sentences packed with adjectives. They feel like they carry meaning, but they distract.
- Don't let an adjective make a claim nobody checked: "zero false positives", "fast", "scalable".
- Clunky is fine, clever is not.
- No hedging.
- Em and long dashes should be super rare: prefer a comma or a period, keep a dash only when it genuinely reads better.

## Say why, not what

The reader sees what the code or the diff does. Say why it is that way, and the non-obvious bits: the intent, the business context behind a decision, the future plans.

When there is a story, tell it in order: the problem, what happens, why it looks this way.

## Structure

- Bullets for lists of facts, one fact per bullet. Reasoning reads better as linked sentences than as bullets.
- Tables when comparing several things. Pad markdown tables with spaces so the pipes line up and the raw text reads as a table.
- Skip the implicit: do not list what did not change.
- Humans need whitespace. Split ideas into blocks with empty lines, so the reader can scan fast and breathe.

## Write for a reader who wasn't there

The reader discovers the text months later. They know nothing about the session, the task, or the reviews that produced it.

- Never "as requested by the user", "as discussed", "per review".
- No change history ("was X, now Y"), it belongs in the commit or the PR.

## Docstrings and comments

- Docstring only when it adds context the code cannot give: the why, a source citation, a non-obvious constraint. Lead with the intent.
- Max 80 characters per line, indentation included.
- Empty lines between blocks.
- No `Args:` / `Returns:` / `Raises:` boilerplate, the types already say it.
- No double backticks around names: ``variable_name`` is forbidden.
- When code copies or mirrors another component, cite the source file or function and list what differs.
- Comments only when they add context beyond the code.
- Default to none. If deleting the comment loses no information for the next reader, delete it. One short comment per function is close to the ceiling.
- In Python, start the docstring on a new line:

```
"""text
blah blah is bad
"""

"""
Text.

Blah Blah blah is much better for humans.
"""
```

Two kinds of comments earn their place. Above a predicate that doesn't read obviously, say how to read it:

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

Never narrate the next line, restate the name of the thing below it, or argue the change to the reviewer (that is PR-description material). In backend tests, `# arrange` / `# act` / `# assert` markers are bare by default; a short appended clause is for saying which case the block covers when a test walks several, not for describing the fixture.

## PR descriptions

- Focus on intent: what the PR achieves and why.
- Give a high level view: how data moves, which concepts change.
- No mechanical description of the diff, the reviewer can read it.
