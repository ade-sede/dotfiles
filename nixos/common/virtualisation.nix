# Virtualisation config — sets Docker as the OCI container backend and imports Docker-specific settings.
{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}: {
  imports = [
    ./virtualisation/docker.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
