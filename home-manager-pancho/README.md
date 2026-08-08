# home-manager-pancho

Self-contained Home Manager configuration for `pancho` on `remote-devbox`.

Shares nothing with ade-sede's config — no imports from `home-manager/common/` or `home-manager/linux/`.

## Usage

Pancho can update his own config:

```bash
home-manager switch --flake .#pancho
```

To add packages, edit `default.nix` and open a PR against this repo.
