{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
        MultiProfile = "multiple";
      };
      A2DP = {
        SBCMaxBitpool = 250;
      };
    };
    package = pkgs.bluez;
  };

  environment.systemPackages = with pkgs; [
    bluez-tools
  ];
}
