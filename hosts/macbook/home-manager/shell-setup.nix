{ config, pkgs, lib, ... }:

{
  home.activation = {
    updateEtcShells = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ "$(uname)" == "Darwin" ]]; then
        fishPath="${config.home.profileDirectory}/bin/fish"
        if ! grep -q "$fishPath" /etc/shells; then
          echo "$fishPath" | sudo tee -a /etc/shells
        fi
        if [[ "$SHELL" != "$fishPath" ]]; then
          chsh -s "$fishPath"
        fi
      fi
    '';
  };
}