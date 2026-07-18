{pkgs, ...}: {
  home.packages = with pkgs; [
    afsctool
  ];
}
