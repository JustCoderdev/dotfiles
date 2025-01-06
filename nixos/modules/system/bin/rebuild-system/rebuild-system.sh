# Thanks 0atman for idea of the script <3, source here
# <https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5>

# Exit alt-buff
echo -ne "\033[?1049l"

# Check filepath
if [ -z "${DOT_FILES:-}" ]; then
	echo -e "\033[31mUnknown dotfiles path\033[0m"
	echo -e "Set DOT_FILES environmental variable in shell"
	exit 1
fi

pushd "${DOT_FILES}/nixos/" > /dev/null || exit
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
	sudo sed -i "s/\(_hostname = \).*/\1\"${HOST_SHELL}\";/" ./flake.nix
fi


# Check differences
echo -ne "Analysing changes..."
if git diff --quiet -- ..; then  # -- ./**/*.nix
	echo -e " \033[31mNot found\033[0m"
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
		git diff --word-diff=porcelain -U0 -- ..
	else
		echo -ne "\n"
	fi

	sudo git add ..
fi


# Rebuild system
echo -n "Rebuilding NixOS... "
echo -ne "\033[?1049h\033[H" # enter alt-buff and clear
echo -e "Rebuilding NixOS...\n"


## Check for online substituters
substituters="https://cache.nixos.org/?priority=40 "
if [ -z "${DOT_NIX_SUB_URL}" ]; then
	echo -e "No nix substituter set, ignoring..."
else
	echo -ne "Found nix substituter '${DOT_NIX_SUB_URL}', pinging... "

	if [[ $(ping -c 4 "${DOT_NIX_SUB_URL}" > /dev/null 2>&1) -eq 0 ]]; then
		echo -e "\033[32mONLINE\033[0m"
		substituters+="http://${DOT_NIX_SUB_URL}"

		if [ -n "${DOT_NIX_SUB_PORT}" ]; then
			#echo -e "No nix substituter port set, leaving default"
		#else
			#echo -e "Using found port '${DOT_NIX_SUB_PORT}'"
			substituters+=":${DOT_NIX_SUB_PORT}"
		fi

		substituters+="?priority=30"
	else
		echo -e "\033[31mOFFLINE\033[0m"
	fi
fi


# Detect processors
procs="$(nproc)"
if [ -z "${procs:-}" ]; then
	echo -e "\033[31mNo processors detected!\033[0m Assuming 2..."
	procs="2"
fi

hprocs="$(( procs * 2 / 3 ))"
echo -e "Detected ${procs} processors, using ${hprocs} of them."

echo -ne "\n"

echo -e "nixos-rebuild switch --show-trace --fallback --max-jobs \"${hprocs}\" --flake \".#${HOST_SHELL}\" --option substituters \"${substituters}\"\n"

set +o pipefail # Disable pipafail since we check ourselves
# shellcheck disable=SC2024 #ah the irony
sudo nixos-rebuild switch --show-trace --fallback --max-jobs "${hprocs}" --flake ".#${HOST_SHELL}" --option substituters "${substituters}" 2>&1 | tee .nixos-switch.log
exit_code="${PIPESTATUS[0]}"
set -o pipefail # Re-enable pipefail

if [[ "${exit_code}" == 0 ]]; then
echo  -e "\n\033[34mNixOS rebuild completed\033[0m (code: $exit_code)"
else
echo  -e "\n\033[31mNixOS rebuild failed\033[0m (code: $exit_code)"
fi

echo -ne "\rExit in 3" && sleep 1
echo -ne "\rExit in 2" && sleep 1
echo -ne "\rExit in 1" && sleep 1
echo -ne "\033[?1049l" # exit alt-buff

if [[ "${exit_code}" == 0 ]]; then
	echo -e "Done\n"

	## Commit changes
	if $had_changes; then
		generation=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
		message="NixOS build ${HOST_SHELL}#${generation}"
		sudo git commit -m "${message}"
		echo -e "\n\n\033[32mCommitted as ${message}\033[0m"
	fi

	echo -e "\033[34mNixOS Rebuild Completed!\033[0m\n"

else
	echo -e "\033[31mFailed\033[0m\n"

	grep --color -F "error" .nixos-switch.log
	if $had_changes; then
		sudo git restore --staged ..
	fi

	echo -ne "\n"

	# shellcheck disable=SC2162
	read -p 'Open log? (y/N): ' log_confirm
	if [[ "${log_confirm}" == [yY] ]] || [[ "${log_confirm}" == [yY][eE][sS] ]]; then
		vim -R .nixos-switch.log
	fi
fi

shopt -u globstar
popd > /dev/null
