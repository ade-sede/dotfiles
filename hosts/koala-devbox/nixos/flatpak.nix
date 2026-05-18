# Flatpak config for koala-devbox — enables Flatpak with nix-flatpak and installs SteamLink.
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
