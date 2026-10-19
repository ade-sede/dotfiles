# remote-devbox

NixOS server machine (x86_64-linux) without a desktop environment.

Used as a remote development box. Runs OpenSSH, a ttyd web terminal exposed over nginx with ACME TLS, an always-online Orca server ([orca.md](./orca.md)), and GPG configured for long-lived remote sessions with curses-based pinentry.
