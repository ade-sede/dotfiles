{ config, pkgs, ... }:

let
  userVars = import ./variables.nix;
in

{
  # Configure programs
  programs = {
    # Fish shell configuration
    fish = {
      enable = true;
      shellInit = ''
        source ~/.dotfiles/dotfiles/fish/config.fish
      '';
    };
    
    git = {
      enable = true;
      extraConfig = {
        core.askPass = "";
      };
    };
    
    neovim = {
      enable = true;
    };
    
    starship = {
      enable = true;
    };

    ssh = {
      enable = true;
      matchBlocks."*" = {
        identityFile = "~/.ssh/id_ed25519";
      };
    };

    # GPG configuration
    gpg = { 
      enable = true;
      settings = {
        no-greeting = true;
        pinentry-mode = "loopback";
      };
    };
  };

  # Create necessary directories and generate keys
  home.activation = {
    createDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.ssh
      
      $DRY_RUN_CMD cat > /tmp/install-omf.fish << 'EOF'
#!/usr/bin/env fish

# Check if OMF is already installed
if not test -d $HOME/.local/share/omf
    # Download the installer
    curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > /tmp/omf-install.fish
    
    # Run the installer non-interactively
    fish /tmp/omf-install.fish --noninteractive --yes
    
    # Clean up
    rm -f /tmp/omf-install.fish
end
EOF

      $DRY_RUN_CMD chmod +x /tmp/install-omf.fish
      $DRY_RUN_CMD ${pkgs.fish}/bin/fish /tmp/install-omf.fish
      
      if [ ! -f ~/.ssh/id_ed25519 ]; then
        $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "${userVars.userEmail}"
        $DRY_RUN_CMD chmod 600 ~/.ssh/id_ed25519
        $DRY_RUN_CMD chmod 644 ~/.ssh/id_ed25519.pub
      fi
      
      # Create machine-specific gitconfig-local with GPG key ID
      $DRY_RUN_CMD mkdir -p ~/.config/git
      if [ ! -f ~/.gitconfig-local ]; then
        # Get the GPG key ID
        GPG_KEY_ID=$(${pkgs.gnupg}/bin/gpg --list-secret-keys --keyid-format=long ${userVars.userEmail} | ${pkgs.gnugrep}/bin/grep sec | ${pkgs.gawk}/bin/awk '{print $2}' | ${pkgs.coreutils}/bin/cut -d'/' -f2)
        
        # Create machine-specific gitconfig-local
        $DRY_RUN_CMD cat > ~/.gitconfig-local << EOF
[user]
	email = ${userVars.userEmail}
	signingkey = $GPG_KEY_ID
EOF
      fi
    '';
  };
}
