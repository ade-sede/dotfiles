#!/usr/bin/env bash
set -e

if ! gpg --list-secret-keys | grep -q "$EMAIL"; then
  echo "Generating GPG key for $EMAIL (this will only happen once)"
  echo "You will be prompted for a passphrase to protect your key"
  cat > /tmp/gpg-gen-key.batch << EOF
%echo Generating GPG key
Key-Type: EDDSA
Key-Curve: ed25519
Key-Usage: sign
Subkey-Type: ECDH
Subkey-Curve: cv25519
Subkey-Usage: encrypt
Name-Real: $FULL_NAME
Name-Email: $EMAIL
Expire-Date: 0
%commit
%echo GPG key generation completed
EOF
  gpg --batch --generate-key /tmp/gpg-gen-key.batch
  rm -f /tmp/gpg-gen-key.batch
else
  echo "GPG key for $EMAIL already exists, nothing to do"
fi