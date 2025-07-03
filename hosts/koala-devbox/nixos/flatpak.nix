{lib, ...}: {
  services.flatpak.enable = true;

  services.flatpak.packages = [
    "com.valvesoftware.SteamLink"
  ];

  environment.sessionVariables = {
    XDG_DATA_DIRS = lib.mkAfter [
      "/var/lib/flatpak/exports/share"
      "$HOME/.local/share/flatpak/exports/share"
    ];
  };
}
