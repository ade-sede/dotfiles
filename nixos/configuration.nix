{ config, pkgs, ... }:

let
  # Automatically fetch Home Manager for NixOS 24.11
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  };
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      # Import Home Manager directly from the fetched tarball
      "${home-manager}/nixos"
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "koala-devbox";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.ade-sede = {
    isNormalUser = true;
    description = "Adrien";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
    ];
    shell = pkgs.fish;
  };

  # Enable programs
  programs = {
    firefox.enable = true;
    fish.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
   # Keep only system-wide packages here
   (pkgs.writeShellScriptBin "claude" ''
     exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
   '')
   pinentry-qt
   # Home manager CLI tool is automatically included when using the NixOS module
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    package = pkgs.gnupg;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Home Manager configuration
  home-manager = {
    users.ade-sede = import ./home-manager/home.nix;
    backupFileExtension = "backup";
    # This ensures the home-manager command is available
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  
  # Ensure GPG key is generated during system rebuild
  system.activationScripts.generateGpgKey = {
    text = ''
      # Get username and email from variables.nix
      userName=$(grep 'userName =' ${./home-manager/variables.nix} | cut -d'"' -f2)
      userEmail=$(grep 'userEmail =' ${./home-manager/variables.nix} | cut -d'"' -f2)
      
      # Generate ED25519 GPG key if it doesn't exist
      if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys | grep -q "$userEmail"; then
        cat > /tmp/gpg-gen-key.batch << EOF
%echo Generating GPG key
Key-Type: EDDSA
Key-Curve: ed25519
Key-Usage: sign
Subkey-Type: ECDH
Subkey-Curve: cv25519
Subkey-Usage: encrypt
Name-Real: $userName
Name-Email: $userEmail
Expire-Date: 0
%no-protection
%commit
%echo GPG key generation completed
EOF
        ${pkgs.gnupg}/bin/gpg --batch --generate-key /tmp/gpg-gen-key.batch
        rm -f /tmp/gpg-gen-key.batch
      fi
    '';
    deps = [];
  };
}
