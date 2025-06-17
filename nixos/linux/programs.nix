{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    fish.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        fuse3
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        curl
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        gtk3
        libGL
        libappindicator-gtk3
        libbsd
        libdrm
        libnotify
        libpulseaudio
        libuuid
        libxkbcommon
        libxml2
        mesa
        nspr
        nss
        pango
        systemd
        vulkan-loader
        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.libxkbfile
        xorg.libxshmfence
      ];
    };
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
