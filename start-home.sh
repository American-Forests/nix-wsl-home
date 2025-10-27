#!/bin/bash
# Script that applies home-manager configuration using user-config.nix
# This does NOT persist the configuration for automatic loading.
# Use enable-home-auto.sh to enable automatic loading on shell startup.

set -e

NIX_HOME_DIR="$HOME/nix-home"

echo "Applying Nix Home Manager configuration..."

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
echo ""
echo "Configuration applied successfully!"
echo ""
echo "To enable automatic loading on shell startup: ./enable-home-auto.sh"
echo "To manually load the environment: ./load-home.sh"
echo ""
exec home-manager switch -b nixbak --flake .