{pkgs, ...}: {
  home.packages = with pkgs; [
    afsctool

    (pkgs.writeShellScriptBin "dust" ''
      exec "${pkgs.nodejs_22}/bin/npx" @dust-tt/dust-cli "$@"
    '')
  ];
}
