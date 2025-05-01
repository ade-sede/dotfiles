{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ./home-manager/variables.nix;
  safeLanding = "${vars.wallpaperDir}/safe-landing.jpg";
in {
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    background=${safeLanding}
    '')
  ];
}
