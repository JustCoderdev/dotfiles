#!/usr/bin/env bash

# Thanks 0atman for the script <3, link here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

# Quit on error
set -e

# cd to your config dir
cd /.dotfiles/nixos/

# Check for differences
echo "Analysing changes..."
if git diff --quiet -- './**/*.nix'; then
	echo "No changes detected, \033[31mexiting\033[0m"
	cd $OLDPWD
	exit 0
fi

# Shows your changes
git diff --word-diff=porcelain -U0 -- './**/*.nix'
echo -e "\nNixOS Rebuilding...\n"

# Rebuild, output simplified errors, log trackebacks
sudo git add .
sudo nixos-rebuild switch --flake .#$1 &>.nixos-switch.log || (cat .nixos-switch.log | grep --color error && false)

# Commit changes 
generation=$(nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
sudo git commit -m "NixOS build#$generation"

echo -e "\n\033[32mCommitted as NixOS build#$generation\033[0m"
echo -e "\033[34mNixOS Rebuild Completed!\033[0m"
cd $OLDPWD
