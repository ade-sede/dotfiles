{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    fish.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    pinentry-qt
  ];

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    package = pkgs.gnupg;
  };
}