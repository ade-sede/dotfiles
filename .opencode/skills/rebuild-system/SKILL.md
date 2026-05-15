______________________________________________________________________

## name: rebuild-system description: Use when applying dotfile changes, activating a new Nix or Home Manager configuration, running home-manager switch, or after any edit to .nix files that needs to take effect. Identifies the correct flake target and checks for interactive steps before deciding whether to run autonomously or hand off to the user.

# Rebuild System

## Command

```bash
home-manager switch --flake .#<flake-name>
```

Run from the dotfiles repository root (`~/.dotfiles`).

## Workflow

1. Use the `detect-machine` skill to determine the current flake name.
1. Check for interactive steps (see section below) before proceeding.
1. If safe to run autonomously, run `home-manager switch --flake .#<flake-name>` from the dotfiles root.
1. On success, confirm the activation completed.
1. On failure, surface the full error output and stop — do not retry automatically.

## Checking for interactive steps

**Always do this check before running the rebuild.** The activation scripts that run during `home-manager switch` can block on stdin waiting for a passphrase. Running autonomously in that state will hang indefinitely.

### What to check

The only interactive step across all hosts is in `home-manager/common/programs/ssh-gpg.nix`.
It runs this during activation:

```bash
ssh-add ~/.ssh/id_ed25519 || true
```

This will prompt for the key's passphrase if all three conditions are true:

1. `~/.ssh/id_ed25519` exists — check with `test -f ~/.ssh/id_ed25519`
1. The key is passphrase-protected — check with `ssh-keygen -y -P "" -f ~/.ssh/id_ed25519 2>/dev/null`; if this command fails, the key has a passphrase
1. The gpg-agent has no cached credential — check with `ssh-add -l`; if the key fingerprint is already listed, it is cached

### Decision

| Condition | Action |
|-------------------------------------------------------------------|---------------------|
| Key does not exist | Rebuild autonomously |
| Key exists but has no passphrase | Rebuild autonomously |
| Key exists, has a passphrase, and is already cached in the agent | Rebuild autonomously |
| Key exists, has a passphrase, and is **not** cached in the agent | Hand off to user |

### Handing off to the user

When autonomous rebuild is not safe, do not attempt to run the command. Instead:

1. Explain to the user that the rebuild will prompt for the SSH key passphrase and cannot be run autonomously.
1. Give them the exact command to run:

```bash
cd ~/.dotfiles && home-manager switch --flake .#<flake-name>
```

3. Tell them what to expect during the run:
   - The Nix build phase runs first — this can take several minutes on the first switch or after significant changes, and will produce verbose output
   - Near the end of activation, a passphrase prompt will appear for `~/.ssh/id_ed25519`
   - The prompt style depends on the host:
     - **koala-devbox** — a Qt GUI dialog box appears on the desktop
     - **remote-devbox** — a `pinentry-curses` TUI prompt appears directly in the terminal
     - **alan-macbook** — a macOS system dialog box appears
   - After entering the passphrase the activation completes and the switch is done

## Notes

- `sudo nixos-rebuild switch` is out of scope for this skill and must not be run.
- Pre-commit hooks run on commit (not on rebuild) — formatting errors will not appear here.
- If the build fails due to a Nix evaluation error, fix the offending `.nix` file first, then rebuild again.
