# Comments

Never comment code or configuration, unless explicitely asked to

# Patterns

When writing new code, base coding style on existing code.

- Follow existing naming conventions
- Mimic existing patterns
- Mimic existing file structure and organization

# Code Philosophy

- Write the minimum amount of code possible
- Never introduce new dependencies without explicit permission
- Optimize for readability, maintainability, and consistency

# Version managements

## Commits

Split distinct changes into separate commits:

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
- Do not try to be exhaustive
- Use imperative mood (e.g., "Add feature" not "Added feature")

## GitHub

Interact with GitHub using the command `gh` (github CLI):

- Use `gh pr create` for pull requests
- Use `gh issue` for issue management
- Use `gh repo` for repository operations

### Pull Requests

Always open PRs as draft.
Check for existing PR templates in standard GitHub locations:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `docs/pull_request_template.md`
- `./PULL_REQUEST_TEMPLATE.md`

Follow the PR format given explicitly in every repo.

If no PR template is provided, use this default format:

```
## Why
- Why these changes were made

## How
- The changes that were made

## Test plan
- [ ] Manual testing completed
- [ ] Existing tests pass
- [ ] New tests added if needed
```
