{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    iotop
    wl-clipboard
  ];
}
