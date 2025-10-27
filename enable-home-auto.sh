#!/bin/bash
# Script to enable automatic home-manager loading on shell startup
# Creates symlinks from ~/.config/home-manager to nix-home configuration files

set -e

NIX_HOME_DIR="$HOME/nix-home"

echo "Enabling automatic home-manager loading..."

cd "$NIX_HOME_DIR"

# Create symlinks to ~/.config/home-manager for automatic discovery
echo "Setting up symlinks to ~/.config/home-manager..."
mkdir -p ~/.config/home-manager

# Create symlinks for the configuration files
for file in flake.nix home.nix user-config.nix; do
    target_path="$HOME/.config/home-manager/$file"
    source_path="$NIX_HOME_DIR/$file"
    
    if [[ -L "$target_path" ]]; then
        # Check if symlink points to correct location
        if [[ "$(readlink "$target_path")" == "$source_path" ]]; then
            echo "Symlink for $file already exists and is correct"
        else
            echo "Updating symlink for $file..."
            rm "$target_path"
            ln -s "$source_path" "$target_path"
        fi
    elif [[ -e "$target_path" ]]; then
        echo "Warning: $target_path exists but is not a symlink. Please remove it manually if you want to enable auto-loading."
        echo "  rm $target_path"
        continue
    else
        echo "Creating symlink for $file..."
        ln -s "$source_path" "$target_path"
    fi
done

echo ""
echo "✓ Automatic home-manager loading enabled!"
echo "  Home-manager will now load automatically in new shell sessions."
echo "  To disable automatic loading, run: ./disable-home-auto.sh"
echo ""