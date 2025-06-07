{
  config,
  pkgs,
  lib,
  ...
}: {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
          ["bluez5.codecs"] = "[ sbc sbc_xq aac ldac aptx aptx_hd ]",
          ["bluez5.a2dp.ldac.quality"] = "high",
        }

        -- Rules for Bluetooth devices
        bluez_monitor.rules = {
          -- Matches all cards
          {
            matches = {
              {
                { "device.name", "matches", "bluez_card.*" },
              },
            },
            apply_properties = {
              ["bluez5.reconnect-profiles"] = "[ a2dp_sink ]",
              ["bluez5.profile"] = "a2dp-sink",
              ["bluez5.auto-connect"] = "[ a2dp_sink ]",
            },
          },
          -- Matches the Bose QC headphones specifically
          {
            matches = {
              {
                { "device.name", "matches", "bluez_card.BC_87_FA_18_B4_5A" },
              },
            },
            apply_properties = {
              ["bluez5.profile"] = "a2dp-sink",
              ["bluez5.auto-connect"] = "[ a2dp_sink ]",
            },
          },
        }
      '')
    ];

    # Force PipeWire to prefer A2DP for all devices
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [44100 48000 88200 96000];
      };
      "context.modules" = [
        {
          name = "libpipewire-module-adapter";
          args = {
            "factory.table" = [
              {
                factory = "bluez5";
                args = {"auto-connect.roles" = ["a2dp_sink"];};
              }
            ];
          };
        }
      ];
    };
  };
}
