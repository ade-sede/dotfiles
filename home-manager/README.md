# Home Manager Configuration

This directory contains the home-manager configuration for the users managed by this repository.

## Getting Started

### Prerequisites

- A system with Nix package manager installed

#### For non-NixOs machines - Enable flakes

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Installation

To re-build user level configuration & packages handled by home manager

```bash
home-manager switch --flake .#<flake-name>
```

Available Home Manager flakes:

- `koala-devbox`
- `alan-macbook`

## Managing packages & configurations

### Installing new packages

Define the packages directly in configuration files:

- `home-manager/common/packages.nix` for user level packages
- `home-manager/desktop-linux` for linux specific GUI packages

And then switch to the new config

```bash
home-manager switch --flake .#<flake-name>
```

### Adding a NPM package through nix

```nix
{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "claude" ''
      exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
    '')
  ];
}
```

This defines `claude` as a shell script that invokes `npx @anthropic-ai/claude-code`.

### Adding a Python package through nix

```nix
{
  home.packages = with pkgs; [
    python311Packages.requests
    python311Packages.numpy
    pythonPackages.pandas
  ];
}
```

### Adding additional configuration for all your software

You can either:

- add a new configuration file under `dotfiles/`
- inline the configuration in nix
- use nix specific configuration options, if the software is supported (example: fish)

Adding a new configuration file as a dotfile is recommended way.

### Adding a dotfile

To add a new dotfile to be managed by Home Manager:

- 1. Add the configuration file in `dotfiles/<software-name>`
- 2. Add a symlink entry in `home-manager/common/dotfiles.nix`
- 3. Apply changes using `home-manager switch --flake .#<flake-name>`

### Importing plasma config

```bash
# Automatically dump config
nix run github:nix-community/plasma-manager > hosts/koala-devbox/home-manager/plasma-config.nix
```

For some reason _shortcuts_ don't work ...
Remove the `shortcut` object manually before commiting the file and use the backup shortcuts in `KDE/` instead.
They can be imported in the system settings UI.
