#!/usr/bin/env bash
# Helpful to test my gpg setup...

echo "Unlocking GPG key..."
echo "test" | gpg --clearsign >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "GPG key unlocked successfully!"
else
    echo "Failed to unlock GPG key"
    exit 1
fi
