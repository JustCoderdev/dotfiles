#!/usr/bin/env bash

# Thanks 0atman for the script, link to gist here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

# Quit on error
set -e

# cd to your config dir
pushd /.dotfiles/nixos/

echo "Analysing changes..."
if git diff --quiet *.nix; then
	echo "No changes detected, exiting"
	popd
	exit 0
fi

# Shows your changes
git diff -U0 *.nix | vi -

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake .#$1 &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

# Commit all changes with the generation metadata
current=$(nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
git commit -am "NixOS: gen $current"

popd
echo "\033[34mNixOS Rebuilt and Committed!\033[0m"
