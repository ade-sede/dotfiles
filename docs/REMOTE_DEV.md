# Remote Development Server Setup

This guide explains how to create a remote development server using the `remote-devbox` flake.

## Prerequisites

- Install Scaleway CLI: `curl -s https://raw.githubusercontent.com/scaleway/scaleway-cli/master/scripts/get.sh | sh`
- Configure authentication: `scw init`

## Create server

Create a server with at least 50GB of disk:

```bash
scw instance server create \
  type=DEV1-L \
  image=ubuntu_jammy \
  name=remote-devbox \
  zone=fr-par-2 \
  root-volume=local:50GB \
  ip=ipv6 \
  cloud-init=@nixos-infect-cloud-init.yaml
```

**Note**: By default Scaleway's flexible IPs come with both IPv4 and IPv6 and we haven't figured out how to do IPv6-only yet.

## Get server IP and monitor installation

```bash
# Get the server IP
scw instance server list zone=fr-par-2

# Check detailed server status
scw instance server get <server-id> zone=fr-par-2

# Check if NixOS installation is complete
ssh root@<server-ip> "nixos-version"

# or Monitor NixOS installation progress (if still installing)
ssh root@<server-ip> "tail -f /tmp/infect.log"
```

## Deploy configuration

```bash
# Copy hardware config to repository
scp root@<server-ip>:/etc/nixos/hardware-configuration.nix ./hosts/remote-devbox/nixos/hardware-config.nix

# Commit and push the hardware config (run from local machine)
git add . && git commit -m "Add remote-devbox hardware config" && git push

# Deploy NixOS configuration
ssh root@<server-ip> "
  git clone https://github.com/ade-sede/dotfiles.git /home/ade-sede/.dotfiles
  chown -R 1000:1000 /home/ade-sede
  cd /home/ade-sede/.dotfiles && git config --global --add safe.directory /home/ade-sede/.dotfiles
  nixos-rebuild switch --flake .#remote-devbox
"

# Test SSH access as ade-sede user (password: changeme)
ssh ade-sede@<server-ip>

# Copy SSH public key for password-less access (run from local machine)
ssh-copy-id ade-sede@<server-ip>
```

## Copy secrets (optional)

After installation is complete, you can copy your local secrets to reuse the same keys:

```bash
# Copy dotfiles/secrets to remote server (since filesystem structure is identical)
scp -r dotfiles/secrets ade-sede@<server-ip>:/home/ade-sede/.dotfiles/dotfiles/
```

## Enable web terminal access

```bash
# Get security group ID from server list
scw instance server list zone=fr-par-2

# Add firewall rule to allow TTYD web terminal (port 3000)
scw instance security-group create-rule security-group-id=<security-group-id> direction=inbound action=accept protocol=TCP dest-port-from=3000 dest-port-to=3000 ip-range=0.0.0.0/0 zone=fr-par-2

# Access web terminal at http://<server-ip>:3000
```

## Server management

```bash
# Stop the server (still charged for storage and IP, but not CPU & RAM)
scw instance server stop <server-id>

# Start the server
scw instance server start <server-id>

# Delete the server (preserves volumes by default)
scw instance server delete <server-id>

# Terminate the server (deletes server and all volumes)
scw instance server terminate <server-id>
```
