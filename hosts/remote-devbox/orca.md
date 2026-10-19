# Orca server

[Orca](https://onorca.dev) runs here as a Remote Orca Server: the box owns the full
runtime (worktrees, terminals, agent sessions), and desktop clients connect to it as
pure UIs. Agents keep running through client disconnects, laptop sleeps and server
reboots.

## How it is wired

- Package: `hosts/remote-devbox/orca-ide.nix`, built from the official
  [`.deb` release](https://github.com/stablyai/orca/releases) (the `.deb` never
  self-updates, so it plays well with the nix store; the AppImage does and is
  avoided).
- Service: `orca-serve`, a home-manager user unit defined in
  `hosts/remote-devbox/home-manager/orca.nix`. It runs
  `orca-ide serve --port 6768 --supervise --no-pairing`, mirroring the unit Orca's
  own `orca serve service install` would write.
- Always online: `users.users.ade-sede.linger = true` in
  `hosts/remote-devbox/nixos/configuration.nix` starts the user manager (and the
  unit) at boot with no login session.

```mermaid
flowchart LR
  laptop[Orca desktop client] -- "SSH tunnel, LocalForward 6768" --> sshd[sshd :22, login:password]
  sshd -- "127.0.0.1:6768" --> orcad[orca-serve :6768]
  internet((internet)) -. "6768 dropped by firewall" .-> orcad
```

## Ports to forward when SSHing

`~/.ssh/config` is generated from `home-manager/common/programs/ssh-gpg.nix` and
already carries these for `ssh devbox`:

| Port | What it reaches |
| ---- | ----------------------------------- |
| 8080 | dev server (existing) |
| 3000 | ttyd web terminal behind nginx |
| 6768 | Orca server (this setup) |

Orca listens on `0.0.0.0:6768` (hardcoded upstream), but the firewall only allows
`22 80 443 3000`, so the port exists solely through the SSH forward. Anyone
without the SSH login has no route to the WebSocket. Clients additionally
authenticate with a per-client pairing token, revocable in Settings → Shared
Server Access.

Never open 6768 in `hosts/remote-devbox/nixos/networking.nix` and never proxy it
through the public nginx vhost: the token would become the only gate on a public
endpoint. If mobile access is ever needed, use Tailscale instead.

## One-time pairing

Pairing happens without the service so the pairing URL (a credential) never
lands in the journal:

```bash
systemctl --user stop orca-serve
orca-ide serve --port 6768 --pairing-address 127.0.0.1   # prints the pairing URL, Ctrl-C when done
systemctl --user start orca-serve
```

Then on the laptop, with `ssh devbox` connected (the tunnel is the pairing
address), in Orca: Settings → Remote Orca Servers → Add Server → paste the URL.
Grants persist across restarts.

Agent subscriptions live on this box, not the laptop:

```bash
orca account add --agent claude   # and codex, etc.
orca account list
```

## Updates

- The orcad server runtime self-updates: `orca serve` parks a bundle in the
  user's home state and updates it there, so server updates never touch the
  store.
- The nix pin (`version` + `hash` in `hosts/remote-devbox/orca-ide.nix`) only
  controls the CLI/launcher. Bump both to update it; Orca ships near-daily on
  the stable channel.

## Docs

- Remote Orca Servers: <https://www.onorca.dev/docs/remote-servers>
- SSH worktrees (the other remote mode): <https://www.onorca.dev/docs/ssh>
- CLI reference: <https://www.onorca.dev/docs/cli/reference>
