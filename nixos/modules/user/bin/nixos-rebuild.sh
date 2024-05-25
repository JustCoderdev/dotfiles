# Thanks 0atman for the script <3, link here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

# Quit on error
set -e

# cd to your config dir
pushd "${DOT_FILES}/nixos/" > /dev/null
shopt -s globstar

# Update hostname
if [ -f "./flake.nix" ]; then
	HOST_FLAKE=$(awk '/hostname = / {print $3}' ./flake.nix)
	# shellcheck disable=SC2001
	HOST_FLAKE=$(echo "${HOST_FLAKE}" | sed 's/"\(.*\)";/\1/')
else
	HOST_FLAKE=""
fi

HOST_SHELL="${HOST:-}"
HOST_INPUT="${1:-}"

echo "HOST_FLAKE: ${HOST_FLAKE}"
echo "HOST_SHELL: ${HOST_SHELL}"
echo "HOST_INPUT: ${HOST_INPUT}"
echo ""

if [ -z "${HOST_INPUT}" ]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOST_SHELL}\033[0m"
else
	echo -e "Requested rebuild for \033[32m\"${HOST_INPUT}\"\033[0m"
	HOST_SHELL="${HOST_INPUT}"
fi

# Update flake file
if [ "${HOST_SHELL}" != "${HOST_FLAKE}" ]; then
	echo -e "Updating flake... (${HOST_FLAKE:---}) -> ($HOST_SHELL)"
	sudo sed -i "s/\(hostname = \).*/\1\"${HOST_SHELL}\";/" "${FLAKE_PATH}/flake.nix"
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
if sudo nixos-rebuild switch --show-trace --flake ".#${HOST_SHELL}" &>.nixos-switch.log; then
	echo -e "Done\n"
else
	echo ""
	grep --color error .nixos-switch.log
	sudo git restore --staged ./**/*.nix

	# shellcheck disable=SC2162
	if read -p 'Open log? (y/N): ' confirm && [[ $confirm == "[yY]" || $confirm == "[yY][eE][sS]" ]]; then
		vim -R .nixos-switch.log
	fi

	shopt -u globstar
	popd > /dev/null
	exit 1
fi

# Commit changes
generation=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
sudo git commit -m "NixOS build ${HOST_SHELL}#${generation}"

echo -e "\n\033[32mCommitted as NixOS build ${HOST_SHELL}#${generation}\033[0m"
echo -e "\033[34mNixOS Rebuild Completed!\033[0m\n"
shopt -u globstar
popd > /dev/null
