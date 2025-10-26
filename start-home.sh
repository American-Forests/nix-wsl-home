#!/bin/bash
# Wrapper script that sources user config, starts home-manager,
# and persists the home-manager configuration in future shell sessions.

if [ ! -f "./setup-home.sh" ]; then
    echo "Error: setup-home.sh not found!"
    echo "Copy setup-home.sh.template to setup-home.sh and customize it with your details."
    exit 1
fi

echo "Sourcing user configuration..."
source ./setup-home.sh

echo "Running home-manager switch..."
exec home-manager switch -b nixbak --flake .#afnix --impure