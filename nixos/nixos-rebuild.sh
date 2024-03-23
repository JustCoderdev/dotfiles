#!/usr/bin/env bash

# Thanks 0atman for the script <3, link here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

dotfiles_path="/.dotfiles"


# Quit on error
set -e

# cd to your config dir
pushd "$dotfiles_path/nixos/" > /dev/null
shopt -s globstar

# Check for differences
echo -e "Analysing changes..."
if git diff --quiet -- ./**/*.nix; then
	echo -e "No changes detected, \033[31mexiting\033[0m\n"
	shopt -u globstar
	popd > /dev/null
	exit 0
fi

# Shows your changes
git diff --word-diff=porcelain -U0 -- ./**/*.nix
echo -e "\nNixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo git add ./**/*.nix
if sudo nixos-rebuild switch --flake ".#$1" &>.nixos-switch.log; then
	echo -e "Done\n"
else
	echo ""
	cat .nixos-switch.log | grep --color error
	sudo git restore --staged ./**/*.nix

	if read -p "Open log? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		cat .nixos-switch.log | vim - 	
	fi


	shopt -u globstar
	popd > /dev/null
	exit 1
fi

# Commit changes 
generation=$(nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
sudo git commit -m "NixOS build#$generation"

echo -e "\n\033[32mCommitted as NixOS build#$generation\033[0m"
echo -e "\033[34mNixOS Rebuild Completed!\033[0m\n"
shopt -u globstar
popd > /dev/null
