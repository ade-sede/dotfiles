# nixos

NixOS system configuration for Linux hosts.

Split into three scopes:

- `common/` — applied to every NixOS host
- `linux/` — applied to Linux NixOS hosts (display server, systemd, programs)
- `hosts/<name>/nixos/` — applied to a single host only

To apply changes, run `sudo nixos-rebuild switch --flake .#<flake-name>` from the repo root. Available flake names: `koala-devbox`, `remote-devbox`.

## Managing generations and storage

List generations:

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

Garbage collect old generations:

```bash
sudo nix-collect-garbage -d
sudo nix-store --optimize
```

Remove generations older than a given timeframe:

```bash
sudo nix-collect-garbage --delete-older-than 14d
```

After cleanup, update the boot menu:

```bash
sudo nixos-rebuild boot --flake .#<flake-name>
```
