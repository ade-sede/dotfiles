# Linux desktop GUI packages — Wayland/Plasma apps, OBS Studio, and the Vivaldi browser.
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    karere
    xclip
    discord
    ghostty
    (vivaldi.override {
      commandLineArgs = ["--ozone-platform=wayland"];
      proprietaryCodecs = true;
      enableWidevine = true;
    })
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
