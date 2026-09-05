# Writing style

Prose style for comments, docstrings, PR descriptions, and docs. Gives substance to the tone rule in `AGENTS.md` ("be concise, sacrifice grammar").

## Plain words

Plain everyday words: readers include non-native speakers and people outside the domain. Swap fancy phrasing:

| Instead of | Write |
|---|---|
| lands as | shows up as |
| kicks in | starts, applies |
| mirrors | is the same as, same shape as |
| untouched | not changed |
| leverages | uses |
| essentially, worth noting, flip side | (just say the thing) |
| eyeball | check, look at |
| delve | look into |

## Short and simple

- Short sentences. Two plain sentences beat one polished one. Clunky is fine, clever is not.
- No hedging.
- Em and long dashes should be super rare: prefer a comma or a period, keep a dash only when it genuinely reads better.

## Say why, not what

The reader sees what the code or the diff does. Say why it is that way, and the non-obvious bits.

## Structure

- Bullets over dense paragraphs, one fact per bullet. Tables when comparing several things.
- Skip the implicit: do not list what did not change.
- Humans need whitespace, cut sentences and use newlines instead of writing 140 chars back to back.

## Docstrings and comments

- Docstring only when it adds context the code cannot give: the why, a source citation, a non-obvious constraint. Lead with the intent, keep it short.
- No `Args:` / `Returns:` / `Raises:` boilerplate, the types already say it.
- When code copies or mirrors another component, cite the source file or function and list what differs.
- Comments only when they add context beyond the code. No change history ("was X, now Y"), that belongs in the commit or PR.
- Default to none. If deleting the comment loses no information for the next reader, delete it. One short comment per function is close to the ceiling.
- In python start with a newline

```
"""text
blah blah is bad
""

"""
Text.

Blah Blah blah is much better for humans.
"""
```
- Never: narrating the next line, restating the name of the thing below it, or arguing the change to the reviewer (that is PR-description material). In backend tests, `# arrange` / `# act` / `# assert` markers are bare by default; a short appended clause is for saying which case the block covers when a test walks several, not for describing the fixture.
