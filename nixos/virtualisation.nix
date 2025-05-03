{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./virtualisation/docker.nix
    ./virtualisation/containers.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
