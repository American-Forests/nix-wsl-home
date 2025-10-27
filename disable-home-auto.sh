#!/bin/bash
# Script to disable automatic home-manager loading on shell startup
# Removes symlinks from ~/.config/home-manager

set -e

echo "Disabling automatic home-manager loading..."

# Remove symlinks from ~/.config/home-manager
config_dir="$HOME/.config/home-manager"

removed_count=0

# Remove symlinks if directory exists
if [[ -d "$config_dir" ]]; then
    for file in flake.nix home.nix user-config.nix; do
        target_path="$config_dir/$file"
        
        if [[ -L "$target_path" ]]; then
            echo "Removing symlink for $file..."
            rm "$target_path"
            removed_count=$((removed_count + 1))
        elif [[ -e "$target_path" ]]; then
            echo "Warning: $target_path exists but is not a symlink. Leaving it unchanged."
        fi
    done
fi

# Remove the directory if it's empty
if [[ -d "$config_dir" ]] && [[ -z "$(ls -A "$config_dir")" ]]; then
    echo "Removing empty ~/.config/home-manager directory..."
    rmdir "$config_dir"
fi

# Check if home-manager profile is active and offer to uninstall it
profile_removed=false
if [[ -L ~/.profile ]] && [[ "$(readlink ~/.profile)" == *"home-manager-files"* ]]; then
    echo "Home-manager profile is currently active."
    echo "To completely disable home-manager, the active profile needs to be uninstalled."
    echo "This will remove home-manager packages from all shell sessions."
    echo ""
    read -p "Uninstall home-manager profile? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstalling home-manager profile..."
        # Use nix-env to remove all packages from the profile
        if nix-env --uninstall '.*' >/dev/null 2>&1; then
            profile_removed=true
            removed_count=$((removed_count + 1))
            echo "Profile uninstalled successfully."
        else
            echo "Warning: Failed to uninstall profile. You may need to uninstall manually."
        fi
    else
        echo "Profile not uninstalled. Home-manager packages will remain available."
    fi
fi

# Check if home-manager profile is currently active
profile_active=false
if [[ -d "$HOME/.nix-profile" ]] && [[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
    profile_active=true
fi

if [[ $removed_count -gt 0 ]]; then
    echo ""
    echo "✓ Home-manager loading disabled!"
    if [[ -d "$config_dir" ]]; then
        echo "  - Removed symlinks from ~/.config/home-manager/"
    fi
    if [[ "$profile_removed" == "true" ]]; then
        echo "  - Uninstalled home-manager profile"
        echo ""
        echo "⚠️  IMPORTANT: Your current shell session may show errors due to missing commands."
        echo "   Please start a NEW terminal session for a clean environment."
        echo ""
        echo "  Home-manager packages are no longer available."
        echo "  To manually load the environment: ./load-home.sh"
        echo "  To re-enable automatic loading: ./enable-home-auto.sh"
    else
        echo ""
        echo "⚠️  Note: Home-manager profile is still active."
        echo "   Packages will remain available until you start a new terminal session"
        echo "   or run this script again and choose to uninstall the profile."
        echo ""
        echo "  To manually load the environment: ./load-home.sh"
        echo "  To re-enable automatic loading: ./enable-home-auto.sh"
    fi
else
    echo ""
    echo "✓ Home-manager loading was already disabled."
fi
echo ""