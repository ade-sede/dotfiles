#!/usr/bin/env bash
set -e

if [ ! -f ~/.ssh/id_ed25519 ]; then
  echo "Generating SSH key (this will only happen once)"
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "$EMAIL"
else
  echo "SSH key already exists, nothing to do"
fi