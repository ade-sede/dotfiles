{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "2fd3d2157d5271ca3575b13daec975ca4c10728a";
          sha256 = "0mb01y1d0g8ilsr5m8a71j6xmqlyhf8w4xjf00wkk8k41cz3ypky";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
    ];

    shellInit = ''
      source ~/.dotfiles/dotfiles/fish/custom_config.fish
    '';

    interactiveShellInit = ''
      set fish_function_path $fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d
      set fish_complete_path $fish_complete_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_completions.d

      function __source_nix_profile
        test -e $HOME/.nix-profile/etc/profile.d/nix.sh && fenv source $HOME/.nix-profile/etc/profile.d/nix.sh
      end

      __source_nix_profile
    '';
  };
}
