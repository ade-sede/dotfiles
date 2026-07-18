# Comments and docstrings

Do not write any comments whatsoever.
However, docstrings are allowed.
When writing docstrings, focus on what the function or variable does.
Do not include information about where the function is used.
Do not include information that only the user you are conversing with would understand.
Do not include anything an actual human being would not include.

The goal of a docstring is to document how a function works and for what purpose, nothing less, nothing more.

# Interaction with the user

Most of our interactions should happen through:

- the `TodoWrite` tool, for planning and tracking changes
- the `AskUserQuestion` tool, for asking the user's input when you are not reasonably able to infer their intent or when a decision needs to be taken

# Model delegation (token/latency optimization)

Delegate implementation to subagents by complexity; orchestration, review of subagent diffs, and final verification stay in the main loop.

| Complexity | Model |
|---|---|
| Delicate (security invariants, race rewrites, subtle domain logic) | main loop |
| Medium (multi-file logic) | `opus` subagent |
| Small/mechanical (single-subsystem, additive, searches, formatting) | `sonnet` subagent |

Each delegated task gets: tight file-level spec, exact verify commands (targeted tests + lint), and its diff is reviewed in the main loop.

# Patterns

- Follow existing naming conventions
- Mimic existing patterns
- Mimic existing file structure and organization

# Code Philosophy

- Write the minimum amount of code possible
- Never introduce new dependencies without explicit permission
- Optimize for readability, maintainability, and consistency

# Version managements

## Commits

If I ever ask you to commit changes, split distinct changes into separate commits:

- Separate features from bug fixes
- Keep refactoring separate from functional changes
- Group related changes together (e.g., all files for one feature)
- Ask whether you should use stacking tool
- Ensure each commit builds, passes the linter, formatter, and tests successfuly

## Stacking & Managing branches

Use `gis` (git-spice)

### Commit Messages

Short, descriptive title; bullet points for details:

- First line: concise summary (50 chars or less)
- Blank line, then bullet points for context
- Focus on why, not what

<!-- - --> Do not try to be exhaustive

- Use imperative mood (e.g., "Add feature" not "Added feature")

## GitHub

Interact with GitHub using the command `gh` (github CLI):

- Use `gh pr create` for pull requests
- Use `gh issue` for issue management
- Use `gh repo` for repository operations

### Pull Requests

- Always open the PRs as draft
- Ask me if I want to use the 'ai-generated' label
- Check for existing PR templates in standard GitHub locations:
  - `.github/pull_request_template.md`
  - `.github/PULL_REQUEST_TEMPLATE.md`
  - `docs/pull_request_template.md`
  - `./PULL_REQUEST_TEMPLATE.md`

Follow the PR format given explicitly in every repo.
