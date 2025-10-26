#!/bin/bash
# Wrapper script that starts home-manager using user-config.nix
# and persists the home-manager configuration in future shell sessions.

set -e

NIX_HOME_DIR="$HOME/nix-home"

echo "Setting up Nix Home Manager configuration..."

cd "$NIX_HOME_DIR"

# Check if user-config.nix has been customized (contains placeholder values)
if grep -q "YOUR_USERNAME_HERE" user-config.nix; then
    echo ""
    echo "==================================================================="
    echo "IMPORTANT: Please edit user-config.nix with your personal information!"
    echo "==================================================================="
    echo ""
    echo "After editing user-config.nix, run this script again to apply the configuration."
    echo ""
    echo "Note: Your local changes to user-config.nix will be ignored by git automatically."
    exit 0
fi

echo "Found user-config.nix, applying Home Manager configuration..."

# Configure git to ignore local changes to user-config.nix (if not already set)
if ! git ls-files -v | grep "^S.*user-config.nix" >/dev/null 2>&1; then
    echo "Configuring git to ignore local changes to user-config.nix..."
    git update-index --skip-worktree user-config.nix
fi

echo "Running home-manager switch..."
exec home-manager switch -b nixbak --flake .#afnix