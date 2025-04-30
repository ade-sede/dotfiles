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
  
  virtualisation.oci-containers.containers.litellm-proxy.autoStart = lib.mkForce true;
}