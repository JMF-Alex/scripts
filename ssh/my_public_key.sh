#!bin/bash
# This script adds my SSH public key to the authorized_keys file.

# Exit immediately if a command exits with a non-zero status, if an undefined variable is used, or if any command in a pipeline fails
set -euo pipefail

# My SSH public key
KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtZogiJmb2yww1bWQbs8hcpeFmMM9hQQZwpTXTsKX5M"

# Define the .ssh directory and authorized_keys file paths
SSH_DIR="$HOME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

# Create the .ssh directory and authorized_keys file if they don't exist, with appropriate permissions
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

# Add the public key to authorized_keys if it's not already present
grep -Fxq "$KEY" "$AUTH_KEYS" || echo "$KEY" >> "$AUTH_KEYS"
