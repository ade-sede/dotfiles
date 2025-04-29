{
  config,
  pkgs,
  lib,
  ...
}: let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  };

  secretsDir = "/home/ade-sede/.dotfiles/secrets";
  geminiKeyFile = "${secretsDir}/gemini_api_key.txt";
  claudeKeyFile = "${secretsDir}/anthropic_api_key.txt";
  openaiKeyFile = "${secretsDir}/openai_api_key.txt";

  readFileIfExists = file:
    if builtins.pathExists file
    then lib.strings.removeSuffix "\n" (builtins.readFile file)
    else "";

  geminiKey = readFileIfExists geminiKeyFile;
  claudeKey = readFileIfExists claudeKeyFile;
  openaiKey = readFileIfExists openaiKeyFile;
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    "${home-manager}/nixos"
    ./docker.nix
  ];

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
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
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
  };

  users.users.ade-sede = {
    isNormalUser = true;
    description = "Adrien";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kate
    ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "claude" ''
      exec ${pkgs.nodePackages.npm}/bin/npx @anthropic-ai/claude-code "$@"
    '')
    (pkgs.writeShellScriptBin "codex" ''
      export ANTHROPIC_API_KEY="${claudeKey}"
      export OPENAI_API_KEY="${openaiKey}"
      export GEMINI_API_KEY="${geminiKey}"
      export FAKE_LITELLM_KEY="sk-litellm-proxy-fake-key"
      exec ${pkgs.nodePackages.npm}/bin/npx @openai/codex "$@"
    '')
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

  system.stateVersion = "24.11"; # Did you read the comment?

  home-manager = {
    users.ade-sede = import ./home-manager/home.nix;
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      cores = 0;
      fsync-metadata = false;
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000;
      max-free = 1000000000;
    };

    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 7;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nix.nrBuildUsers = 32;

  systemd = {
    extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=10s
      DefaultStartLimitIntervalSec=10s
      DefaultStartLimitBurst=5
    '';

    network.wait-online.enable = false;
    user.services.dbus.startLimitBurst = 500;

    services = {
      generate-gpg-key = {
        enable = false;
        description = "Generate GPG key if it doesn't exist";
        wantedBy = ["default.target"];
        partOf = ["graphical-session.target"];
        after = ["network.target"];

        startLimitIntervalSec = 0;
        serviceConfig = {
          Type = "oneshot";
          User = "ade-sede";
          RemainAfterExit = true;
        };

        script = ''
                    userName=$(grep 'userName =' ${./home-manager/variables.nix} | cut -d'"' -f2)
                    userEmail=$(grep 'userEmail =' ${./home-manager/variables.nix} | cut -d'"' -f2)

                    if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys | grep -q "$userEmail"; then
                      echo "Generating GPG key for $userEmail (this will only happen once)"
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
                    else
                      echo "GPG key for $userEmail already exists, nothing to do"
                      exit 0
                    fi
        '';
      };

      generate-ssh-key = {
        enable = false;
        description = "Generate SSH key if it doesn't exist";
        wantedBy = ["default.target"];
        partOf = ["graphical-session.target"];
        after = ["network.target"];

        startLimitIntervalSec = 0;
        serviceConfig = {
          Type = "oneshot";
          User = "ade-sede";
          RemainAfterExit = true;
        };

        script = ''
          userEmail=$(grep 'userEmail =' ${./home-manager/variables.nix} | cut -d'"' -f2)

          if [ ! -f /home/ade-sede/.ssh/id_ed25519 ]; then
            echo "Generating SSH key (this will only happen once)"
            ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f /home/ade-sede/.ssh/id_ed25519 -N "" -C "$userEmail"
          else
            echo "SSH key already exists, nothing to do"
            exit 0
          fi
        '';
      };
    };
  };
}
