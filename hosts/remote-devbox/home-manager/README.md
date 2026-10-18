# hosts/remote-devbox/home-manager

Host-specific Home Manager configuration for remote-devbox.

Extends the common and Linux Home Manager modules with a GPG agent tuned for remote use (curses pinentry, maximised cache TTLs) and Plannotator env overrides that keep opencode's TUI clean over SSH (no stderr notice, port 19432). No desktop packages.
