# Thanks 0atman for idea of the script <3, source here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

# Quit on error
set -e


# Check filepath
if [ -z "${DOT_FILES:-}" ]; then
	echo -e "\033[31mUnknown dotfiles path\033[0m"
	echo -e "Set DOT_FILES environmental variable in shell"
	exit 1
fi

pushd "${DOT_FILES}/nixos/" > /dev/null
shopt -s globstar


# Update host
if [ -f "./flake.nix" ]; then
	HOST_FLAKE=$(awk '/_hostname = / {print $3}' ./flake.nix)
	# shellcheck disable=SC2001
	HOST_FLAKE=$(echo "${HOST_FLAKE}" | sed 's/"\(.*\)";/\1/')
else
	HOST_FLAKE=""
fi

HOST_SHELL="${HOST:-}"
HOST_INPUT="${1:-}"

# echo "HOST_FLAKE: ${HOST_FLAKE}"
# echo "HOST_SHELL: ${HOST_SHELL}"
# echo "HOST_INPUT: ${HOST_INPUT}"
# echo ""

## Check for input
if [ -z "${HOST_INPUT}" ]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOST_SHELL}\033[0m"
else
	echo -e "Requested rebuild for \033[32m\"${HOST_INPUT}\"\033[0m"
	HOST_SHELL="${HOST_INPUT}"
fi

## Update flake file
if [ "${HOST_SHELL}" != "${HOST_FLAKE}" ]; then
	echo "Updating flake... (${HOST_FLAKE:---}) -> ($HOST_SHELL)"
	sudo sed -i "s/\(_hostname = \).*/\1\"${HOST_SHELL}\";/" "${FLAKE_PATH}/flake.nix"
fi


# Check differences
echo -ne "Analysing changes..."
if git diff --quiet -- .; then  # -- ./**/*.nix
	echo -e " \033[31mNo changes detected\033[0m"
	had_changes=false
	# echo -e "No changes detected, \033[31mexiting\033[0m\n"
	# shopt -u globstar
	# popd > /dev/null
	# exit 0
else
	echo " Found"
	had_changes=true

	# shellcheck disable=SC2162
	read -p 'Open diff? (y/N): ' diff_confirm
	if [[ "${diff_confirm}" == [yY] ]] || [[ "${diff_confirm}" == [yY][eE][sS] ]]; then
		git diff --word-diff=porcelain -U0 -- .
	fi

	sudo git add .
fi


# Rebuild system
echo -n "Rebuilding NixOS..."

# shellcheck disable=SC2024 #ah the irony
if sudo nixos-rebuild switch --show-trace --flake ".#${HOST_SHELL}" &>.nixos-switch.log; then
	echo -e " Done\n"

	## Commit changes
	generation=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
	if $had_changes; then
		sudo git commit -m "NixOS build ${HOST_SHELL}#${generation}"
	fi

	echo -e "\n\033[32mCommitted as NixOS build ${HOST_SHELL}#${generation}\033[0m"
	echo -e "\033[34mNixOS Rebuild Completed!\033[0m\n"

else
	echo -e " \033[31mFailed\033[0m"

	grep --color error .nixos-switch.log
	if $had_changes; then
		sudo git restore --staged .
	fi

	# shellcheck disable=SC2162
	read -p 'Open log? (y/N): ' log_confirm
	if [[ "${log_confirm}" == [yY] ]] || [[ "${log_confirm}" == [yY][eE][sS] ]]; then
		vim -R .nixos-switch.log
	fi
fi

shopt -u globstar
popd > /dev/null
