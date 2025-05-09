{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pinentry-qt
    home-manager
  ];

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
    package = pkgs.gnupg;
  };
}
