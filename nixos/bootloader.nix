{
  config,
  pkgs,
  lib, ...
}: { 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.plymouth = {
    enable = true;
    theme = "colorful_loop";
    themePackages = with pkgs; [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ "colorful_loop" ];
      })
    ];
  };
  
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];
  boot.initrd.systemd.enable = true;
}
