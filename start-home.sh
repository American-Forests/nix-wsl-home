#!/bin/bash
# Wrapper script that sources user config, starts home-manager,
# and persists the home-manager configuration in future shell sessions.

NIX_HOME_DIR="$HOME/nix-home"

if [ ! -f "$NIX_HOME_DIR/setup-home.sh" ]; then
    echo "Error: setup-home.sh not found at $NIX_HOME_DIR/setup-home.sh!"
    echo "Copy setup-home.sh.template to setup-home.sh and customize it with your details."
    exit 1
fi

echo "Sourcing user configuration..."
source "$NIX_HOME_DIR/setup-home.sh"

echo "Running home-manager switch..."
cd "$NIX_HOME_DIR"
exec home-manager switch -b nixbak --flake .#afnix --impure