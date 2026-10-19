# Orca package for remote-devbox — built from the official .deb. orcad-template must stay byte-identical (its files are checksum-verified when the serve slot is prepared), so it is copied in after autoPatchelf and its binaries run through the host's nix-ld instead.
{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libdrm,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "orca-ide";
  version = "1.4.229";

  src = fetchurl {
    url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-ide_${version}_amd64.deb";
    hash = "sha256-7TNqh4iWW1mHkIITcPUOC40C8sqJrdOGZt8F6A5jKOQ=";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libGL
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxshmfence
  ];

  unpackPhase = "dpkg-deb -x $src .";

  postPatch = ''
    patchShebangs opt/Orca/resources/bin/orca-ide
    rm -rf opt/Orca/resources/orcad-template/targets/{darwin-arm64,darwin-x64,linux-arm64-glibc,linux-arm64-musl,linux-x64-glibc217,linux-x64-musl,win32-arm64,win32-x64}
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt $out/bin
    cp -r opt/Orca $out/opt/Orca
    rm -rf $out/opt/Orca/resources/orcad-template
    addAutoPatchelfSearchPath "$out/opt/Orca"
    ln -s $out/opt/Orca/resources/bin/orca-ide $out/bin/orca-ide
    runHook postInstall
  '';

  postPhases = ["orcaTemplatePhase"];

  orcaTemplatePhase = ''
    cp -r opt/Orca/resources/orcad-template $out/opt/Orca/resources/orcad-template
  '';
}
