{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  environment.systemPackages = with pkgs; [
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