# Key Management

This directory contains scripts for generating GPG and SSH keys.

## Generating Keys

GPG & SSH keys can be generated using scripts in this directory:

```bash
# Generate SSH key
../scripts/key-management/generate-ssh-key.sh

# Generate GPG key
../scripts/key-management/generate-gpg-key.sh
```

These scripts use the environment variables `FULL_NAME` and `EMAIL` which are set automatically by home-manager.

## Uploading security keys to GitHub

The keys are not automatically uploaded to GitHub.

```fish
# List GPG keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Export GPG public key to a file
gpg --armor --export <KEY_ID> > gpg_github_key.asc

# Login into GH cli (use browser auth - generating an access token is not necessary)
gh auth login

# Make sure we are allowed to push gpg keys
gh auth refresh -s  write:gpg_key

# Add the key to GitHub using GitHub CLI
gh gpg-key add gpg_github_key.asc

# Clean up
rm gpg_github_key.asc

# Add the SSH key to GitHub using GitHub CLI
gh auth login  # First authenticate with GitHub if needed
gh ssh-key add ~/.ssh/id_ed25519.pub -t "koala-devbox" # Should be pushed automatically if it exists when logging in for the first time
```
