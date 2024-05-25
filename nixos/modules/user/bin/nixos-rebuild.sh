# Thanks 0atman for the script <3, link here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

# Quit on error
set -e

# cd to your config dir
pushd "${DOT_FILES}/nixos/" > /dev/null
shopt -s globstar

# Update hostname
if [ -z "${1:-$HOST}" ]; then
	echo -e "Host not passed, defaulting to \033[32m#\033[0m"
else
	echo -e "Requested rebuild for \"\033[32m${1:-$HOST}\033[0m\". Updating flake file..."
	sed -i "s/\(hostname = \).*/\1\"${1:-$HOST}\";/" "${DOT_FILES}/nixos/flake.nix"
fi

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

# shellcheck disable=SC2024 #ah the irony
if sudo nixos-rebuild switch --show-trace --flake ".#${1:-$HOST}" &>.nixos-switch.log; then
	echo -e "Done\n"
else
	echo ""
	grep --color error .nixos-switch.log
	sudo git restore --staged ./**/*.nix

	if read -pr "Open log? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		vim -R .nixos-switch.log
	fi

	shopt -u globstar
	popd > /dev/null
	exit 1
fi

# Commit changes
generation=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
sudo git commit -m "NixOS build ${1:-$HOST}#${generation}"

echo -e "\n\033[32mCommitted as NixOS build ${1:-$HOST}#${generation}\033[0m"
echo -e "\033[34mNixOS Rebuild Completed! ${1:-$HOST}\033[0m\n"
shopt -u globstar
popd > /dev/null
