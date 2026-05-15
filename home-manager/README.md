# home-manager

Home Manager configuration for all managed users.

Split into three scopes:

- `common/` — applied to every host (Linux and macOS)
- `linux/` — applied to Linux hosts only
- `hosts/<name>/home-manager/` — applied to a single host only

To apply changes, run `home-manager switch --flake .#<flake-name>` from the repo root. Available flake names: `koala-devbox`, `remote-devbox`, `alan-macbook`.

## Adding dotfiles

To add a new dotfile:

1. Place the config file under `dotfiles/<program-name>/`
1. Add a symlink entry in `home-manager/common/dotfiles.nix`
1. Rebuild with `home-manager switch --flake .#<flake-name>`

## Importing KDE Plasma config

```bash
nix run github:nix-community/plasma-manager > hosts/koala-devbox/home-manager/plasma-config.nix
```

Remove the `shortcuts` attribute before committing — shortcuts do not import correctly via plasma-manager. Use the backup in `KDE/` and import them through System Settings instead.
