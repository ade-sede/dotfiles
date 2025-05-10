{ config, pkgs, lib, ... }:

{
  home.activation = {
    symlinkAlanBinaries = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -d "$HOME/.alan/bin" ]; then
        for file in $HOME/.nix-profile/bin/*; do
          if [ -f "$file" ] && [ -x "$file" ]; then
            target="$HOME/.alan/bin/$(basename "$file")"
            if [ -L "$target" ] && [ "$(readlink "$target")" != "$file" ]; then
              rm "$target"
            fi
            if [ ! -e "$target" ]; then
              ln -s "$file" "$target"
            fi
          fi
        done
      fi
    '';
  };
}