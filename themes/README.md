# themes

Central color palette definitions for all theme variants.

Each variant (`light`, `dark`, `dracula`) is a flat attribute set of hex color strings and application-specific values consumed by every program module via the `theme` specialArg. The active variant is selected per-host in `hosts/<name>/constants.nix`.

See `THEME.md` at the repo root for a full explanation of how themes are injected into individual applications.
