#!/bin/bash
# Wrapper script that starts home-manager using user-config.nix
# and persists the home-manager configuration in future shell sessions.

set -e

NIX_HOME_DIR="$HOME/nix-home"

echo "Setting up Nix Home Manager configuration..."

cd "$NIX_HOME_DIR"

# Create symlinks to ~/.config/home-manager for automatic discovery
echo "Setting up symlinks to ~/.config/home-manager..."
mkdir -p ~/.config/home-manager

# Create symlinks for the configuration files
for file in flake.nix home.nix user-config.nix; do
    target_path="$HOME/.config/home-manager/$file"
    source_path="$NIX_HOME_DIR/$file"
    
    if [[ -L "$target_path" ]]; then
        # Remove existing symlink if it points to a different location
        if [[ "$(readlink "$target_path")" != "$source_path" ]]; then
            echo "Updating symlink for $file..."
            rm "$target_path"
            ln -s "$source_path" "$target_path"
        fi
    elif [[ -e "$target_path" ]]; then
        echo "Warning: $target_path exists but is not a symlink. Skipping..."
    else
        echo "Creating symlink for $file..."
        ln -s "$source_path" "$target_path"
    fi
done

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
exec home-manager switch -b nixbak