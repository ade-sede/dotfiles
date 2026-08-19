{pkgs, ...}: {
  home.packages = with pkgs; [
    afsctool

    (pkgs.writeShellScriptBin "dust" ''
      exec "${pkgs.nodePackages.npm}/bin/npx" @dust-tt/dust-cli "$@"
    '')
  ];
}
