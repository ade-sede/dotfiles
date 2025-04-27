{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vim
    wget
    nodejs
    git
    tmux
    ghostty
    discord
    starship
    curl
    fzf
    python3
    python311Packages.pip
    eza
    github-cli
    bat
    coreutils
    gnugrep
    gawk
    findutils
    cmake
    gnumake
    gcc
    # Custom Vivaldi with qt6 and wayland support
    (let
      customVivaldi = vivaldi.overrideAttrs (oldAttrs: {
        buildPhase = builtins.replaceStrings
          ["for f in libGLESv2.so libqt5_shim.so ; do"]
          ["for f in libGLESv2.so libqt5_shim.so libqt6_shim.so ; do"]
          oldAttrs.buildPhase;
      });
    in
      customVivaldi.override {
        qt5 = qt6;
        commandLineArgs = [ "--ozone-platform=wayland" ];
        proprietaryCodecs = true;
        enableWidevine = true;
      }
    )
  ];
}
