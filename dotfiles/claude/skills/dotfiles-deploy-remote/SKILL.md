______________________________________________________________________

## name: dotfiles-deploy-remote description: > Provision and deploy a remote development server on Scaleway end-to-end: create server, wait for NixOS install, deploy dotfiles, set up SSH access, and optionally enable the web terminal.

# Dotfiles Deploy Remote

Use this skill to create a new remote development server on Scaleway and deploy the dotfiles configuration.

## Prerequisites

Confirm with the user that the Scaleway CLI is configured:
```bash
scw instance server list
```

If this fails, stop and ask the user to run `scw init` first.

## Workflow

### 1. Create Server

Read `docs/REMOTE_DEV.md` for the full procedure. Create the server:

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

### 2. Get Server IP and Monitor Installation

```bash
scw instance server list zone=fr-par-2
```

Note the server ID and IP. Monitor progress:
```bash
ssh root@<server-ip> "tail -f /tmp/infect.log"
```

Wait until the NixOS installation completes (check with `ssh root@<server-ip> "nixos-version"`).

### 3. Deploy Configuration

Read `docs/REMOTE_DEV.md` for the deploy procedure. Execute:

```bash
# Copy hardware config
scp root@<server-ip>:/etc/nixos/hardware-configuration.nix ./hosts/remote-devbox/nixos/hardware-config.nix

# Commit and push
git add . && git commit -m "Add remote-devbox hardware config" && git push

# Deploy NixOS
ssh root@<server-ip> "
  git clone https://github.com/ade-sede/dotfiles.git /home/ade-sede/.dotfiles
  chown -R 1000:1000 /home/ade-sede
  cd /home/ade-sede/.dotfiles && git config --global --add safe.directory /home/ade-sede/.dotfiles
  nixos-rebuild switch --flake .#remote-devbox
"
```

### 4. Set Up SSH Access

Use the password `changeme` for the initial login. If the agent cannot handle interactive password prompts, use the `expect` pattern from `docs/REMOTE_DEV.md`:

```bash
expect -c "
  spawn ssh -o StrictHostKeyChecking=no ade-sede@<server-ip> whoami
  expect \"password:\"
  send \"changeme\r\"
  expect eof
"
```

Then set up passwordless access:
```bash
ssh-copy-id ade-sede@<server-ip>
```

And change the default password:
```bash
ssh ade-sede@<server-ip> "passwd ade-sede"
```

### 5. Copy Secrets (Optional)

```bash
scp -r secrets ade-sede@<server-ip>:/home/ade-sede/.dotfiles/
```

### 6. Generate Keys (Optional)

If new keys are needed, follow `docs/KEY_MANAGEMENT.md`.

### 7. Enable Web Terminal (Optional)

```bash
# Get security group ID
scw instance server list zone=fr-par-2

# Add firewall rule
scw instance security-group create-rule security-group-id=<id> \
  direction=inbound action=accept protocol=TCP \
  dest-port-from=3000 dest-port-to=3000 ip-range=0.0.0.0/0 zone=fr-par-2
```

### 8. Report

Tell the user:
- Server IP and ID
- NixOS version installed
- SSH access status (passwordless: yes/no)
- Web terminal status (enabled/disabled)
- Any steps that failed or need manual attention
