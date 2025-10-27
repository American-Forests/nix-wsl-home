#!/bin/bash
# Script to manually load home-manager environment in the current shell
# This provides a one-time activation without persisting for future sessions

set -e

NIX_HOME_DIR="$HOME/nix-home"

echo "Loading home-manager environment..."

# Check if configuration exists
if [[ ! -f "$NIX_HOME_DIR/user-config.nix" ]]; then
    echo "Error: user-config.nix not found in $NIX_HOME_DIR"
    echo "Please run ./load-home.sh first to set up your configuration."
    exit 1
fi

# Check if user-config.nix has been customized
if grep -q "YOUR_USERNAME_HERE" "$NIX_HOME_DIR/user-config.nix"; then
    echo ""
    echo "==================================================================="
    echo "IMPORTANT: Please edit user-config.nix with your personal information!"
    echo "==================================================================="
    echo ""
    echo "After editing user-config.nix, run this script again to load the environment."
    echo ""
    echo "Note: Your local changes to user-config.nix will be ignored by git automatically."
    exit 0
fi

cd "$NIX_HOME_DIR"

# Configure git to ignore local changes to user-config.nix (if not already set)
if ! git ls-files -v | grep "^S.*user-config.nix" >/dev/null 2>&1; then
    echo "Configuring git to ignore local changes to user-config.nix..."
    git update-index --skip-worktree user-config.nix
fi

echo "Activating home-manager environment for current session..."

# Use nix shell to temporarily activate the home-manager environment
# This doesn't require the configuration to be in ~/.config/home-manager
exec nix shell nixpkgs#home-manager --command bash -c "
    echo '✓ Home-manager environment loaded!'
    echo '  Commands like neofetch, jq, gh, awscli, and starship are now available.'
    echo '  This activation is temporary and will not persist to new shell sessions.'
    echo ''
    echo 'To enable automatic loading: ./enable-home-auto.sh'
    echo 'To exit this environment: exit'
    echo ''
    # Source the home-manager session variables if they exist
    if [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
        source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    fi
    # Start a new bash session with the home-manager environment
    exec bash
"