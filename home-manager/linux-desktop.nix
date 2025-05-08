{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    xclip
    discord
    ghostty
    (
      let
        customVivaldi = vivaldi.overrideAttrs (oldAttrs: {
          buildPhase =
            builtins.replaceStrings
            ["for f in libGLESv2.so libqt5_shim.so ; do"]
            ["for f in libGLESv2.so libqt5_shim.so libqt6_shim.so ; do"]
            oldAttrs.buildPhase;
        });
      in
        customVivaldi.override {
          qt5 = qt6;
          commandLineArgs = ["--ozone-platform=wayland"];
          proprietaryCodecs = true;
          enableWidevine = true;
        }
    )
  ];
}
