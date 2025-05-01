{ pkgs, lib, ... }: 
let
  vars = import ./variables.nix;
  safeLanding = "${vars.wallpaperDir}/safe-landing.jpg";
  shortcutsFile = "${vars.kdeDir}/kde-shortcuts.kksrc";
  kwinRulesFile = "${vars.kdeDir}/kwin-rules.kwinrule";
in {
  home.packages = with pkgs; [
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

  programs.plasma = {
    enable = true;
    workspace = {
      wallpaper = safeLanding;
    };
    kscreenlocker = {
      appearance = {
        wallpaper = safeLanding;
      };
    };
    shortcuts = {
      kwin = {
        "Switch to Desktop 1" = [ "Meta+1" "Ctrl+F1" ];
        "Switch to Desktop 2" = [ "Meta+2" "Ctrl+F2" ];
        "Switch to Desktop 3" = [ "Meta+3" "Ctrl+F3" ];
        "Switch to Desktop 4" = [ "Meta+4" "Ctrl+F4" ];
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";
        "Switch to Desktop 10" = "Meta+0";
        
        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";
        "Window to Desktop 6" = "Meta+^";
        "Window to Desktop 7" = "Meta+&";
        "Window to Desktop 8" = "Meta+*";
        "Window to Desktop 9" = "Meta+(";
        "Window to Desktop 10" = "Meta+)";
        
        "Window Close" = [ "Alt+F4" "Meta+Shift+Q" ];
        "ShowDesktopGrid" = [ "Ctrl+Up" "Ctrl+F8" ];
        
        "Switch Window Down" = "Meta+Alt+Down";
        "Switch Window Left" = "Meta+Alt+Left";
        "Switch Window Right" = "Meta+Alt+Right";
        "Switch Window Up" = "Meta+Alt+Up";
        
        "Window Maximize" = "Meta+E";
        "Window Fullscreen" = "Meta+F";
        "Window Quick Tile Bottom" = "Meta+Down";
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";
        "Window Quick Tile Top" = "Meta+Up";
      };
      
      ksmserver = {
        "Lock Session" = [ "Ctrl+Alt+L" "Screensaver" "Meta+L" ];
      };
      
      "org_kde_krunner_desktop" = {
        "_launch" = [ "Search" "Alt+F2" "Alt+Space" "Meta+D" ];
      };
      
      plasmashell = {
        "manage activities" = "Meta+Q";
        "next activity" = "Meta+Tab";
        "previous activity" = "Meta+Shift+Tab";
      };
      
      "khotkeys" = {
        "ghostty" = "Meta+Return";
      };
    };
    input = {
      keyboard = {
        repeatDelay = 200;
        repeatRate = 25;
      };
    };
    kwin = {
      nightLight = {
        enable = true;
        mode = "location";
        temperature = {
          day = 6500;
          night = 4500;
        };
        location = {
          latitude = "45.75";
          longitude = "4.85";
        };
      };
      virtualDesktops = {
        names = [
          "System"
          "Discord"
          "Browser"
          "Terminal"
        ];
        rows = 1;
      };
    };
    window-rules = [
      {
        description = "Discord";
        match = {
          window-class = {
            value = "discord";
            type = "substring";
          };
        };
        apply = {
          desktop = {
            value = "Discord";
            apply = "force";
          };
        };
      }
      {
        description = "Ghostty";
        match = {
          window-class = {
            value = "ghostty";
            type = "substring";
          };
        };
        apply = {
          desktop = {
            value = "Terminal";
            apply = "force";
          };
        };
      }
      {
        description = "New window settings";
        match = {
          window-class = {
            value = ".*";
            type = "regex";
          };
        };
        apply = {
          position-x = {
            value = 40;
            apply = "force";
          };
          position-y = {
            value = 70;
            apply = "force";
          };
          size-width = {
            value = 1500;
            apply = "force";
          };
          size-height = {
            value = 800;
            apply = "force";
          };
        };
      }
      {
        description = "System Settings";
        match = {
          window-class = {
            value = "System Settings";
            type = "substring";
          };
        };
        apply = {
          desktop = {
            value = "System";
            apply = "force";
          };
        };
      }
      {
        description = "Vivaldi";
        match = {
          window-class = {
            value = "vivaldi";
            type = "substring";
          };
        };
        apply = {
          desktop = {
            value = "Browser";
            apply = "force";
          };
        };
      }
    ];
  };
}
