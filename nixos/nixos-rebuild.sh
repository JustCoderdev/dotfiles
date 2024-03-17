#!/usr/bin/env bash

# Thanks 0atman for the script, link to gist here
# <>

# A rebuild script that commits on a successful build
set -e

# cd to your config dir
pushd /.dotfiles/nixos/

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet *.nix; then
    echo "No changes detected, exiting."
   popd
    exit 0
fi

# Edit your config
sudo $EDITOR configuration.nix

# Autoformat your nix files
alejandra . >/dev/null

# Shows your changes
git diff -U0 *.nix

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
