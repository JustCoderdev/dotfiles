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

pushd "${DOT_FILES}/" > /dev/null || exit
shopt -s globstar

publish_on_discord () {
	message_raw="${1}"
	message_raw=${message_raw//\\/\\\\} # \
	message_raw=${message_raw//\//\\\/} # /
	# message_raw=${message_raw//\'/\\\'} # ' (not strictly needed ?)
	message_raw=${message_raw//\"/\\\"} # "
	message_raw=${message_raw//	/\\t} # \t (tab)
	message_raw=${message_raw//
/\\n} # \n (newline)
	message_raw=${message_raw///\\r} # \r (carriage return)
	message_raw=${message_raw///\\f} # \f (form feed)
	message=${message_raw///\\b} # \b (backspace)

	discordhook_path="${DOT_FILES}/secrets/discord/foxburrow/rebuilds-hook.url"
	if [ -e "${discordhook_path}" ]; then
		# completed_message="\`\`\`ansi\n\u001b[35m[${USER}@${HOSTNAME}]\u001b[0m ${message}\n\`\`\`"
		completed_message="## [${HOSTNAME}] ${message}"
		curl -s -X POST -H 'content-type: application/json' -d "{ \"content\": \"${completed_message}\" }" "$(cat "${discordhook_path}")"
	else
		echo -e "Discord hook url was not found, ignoring"
	fi
}


# Check for input
HOST_SHELL="${HOSTNAME:-}"
MODE_INPUT="${1:-}"
HOST_INPUT="${2:-}"

if [ -z "${MODE_INPUT}" ]; then
	echo -e "\033[31mRebuild mode not passed\033[0m"
	echo "Execute script with one of: '--switch' or '--boot'"
	exit 1
fi

if [ -z "${HOST_INPUT}" ]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOST_SHELL}\033[0m"
else
	echo -e "Requested rebuild for \033[32m\"${HOST_INPUT}\"\033[0m"
	export HOSTNAME="${HOST_INPUT}"
fi

# Check differences
echo -ne "\nAnalysing changes... "
if git diff --quiet -- .; then  # -- ./**/*.nix
	echo -e "\033[31mNot found\033[0m"
	had_changes=0
else
	echo 'Found'
	had_changes=1

	## Update flake
	echo -e "Locking jcbin and jcconfs\n";
	nix --extra-experimental-features 'nix-command flakes' flake update jcbin jcconfs

	# shellcheck disable=SC2162
	read -rp 'Do you want to commit? (y/N): ' commit_confirm
	if [[ "${commit_confirm}" == [yY] ]] || [[ "${commit_confirm}" == [yY][eE][sS] ]];
	then
		prefix="NixOS build ${HOSTNAME}"
		read -rp "${prefix}: " commit_msg
		message="${message}: ${commit_msg}"

		git commit -m "${message}"
		echo -e "\n\n\033[32mCommitted as ${message}\033[0m"
	fi

	echo -ne "\n"
fi

# Rebuild system
echo -n "Rebuilding NixOS... "
echo -ne "\033[?1049h\033[2J\033[H" # enter alt-buff and clear
echo -e "Rebuilding NixOS...\n"

# Detect processors
procs="$(nproc)"
if [ -z "${procs:-}" ]; then
	echo -e "\033[31mNo processors detected!\033[0m"
	procs="2"
fi

hprocs=$((procs - 1))
echo -e "Detected ${procs} processors, using ${hprocs} of them."
echo -ne "\n"

mode="switch"
case $MODE_INPUT
in
	--switch) mode='switch' ;;
	--boot)   mode='boot'   ;;
esac

echo -e "nixos-rebuild ${mode} --max-jobs \"${hprocs}\" --flake \".#${HOSTNAME}\" \n"
set +o pipefail # Disable pipafail since we check ourselves
# shellcheck disable=SC2024 #ah the irony
sudo nixos-rebuild "${mode}" --show-trace --fallback --max-jobs "${hprocs}" --flake ".#${HOSTNAME}" 2>&1 | tee .nixos-switch.log
exit_code="${PIPESTATUS[0]}"
set -o pipefail # Re-enable pipefail

if [[ "${exit_code}" == 0 ]];
then
	echo -e "\n\033[34mNixOS rebuild completed\033[0m (code: $exit_code)"
else
	echo -e "\n\033[31mNixOS rebuild failed\033[0m (code: $exit_code)"
fi

echo -ne "\rExit in 3" && sleep 1
echo -ne "\rExit in 2" && sleep 1
echo -ne "\rExit in 1" && sleep 1
echo -ne "\033[?1049l" # exit alt-buff # clear screen \033[2J

if [[ "${exit_code}" == 0 ]]; then
	echo -e "Done\n"

	if [[ "${had_changes}" -ne 0 ]];
	then
		generation=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
		publish_on_discord "NixOS rebuild #${generation} completed"
	else
		publish_on_discord "NixOS rebuild completed"
	fi

	echo -e "\033[34mNixOS Rebuild Completed!\033[0m\n"

else
	echo -e "\033[31mFailed\033[0m\n"
	msg=$'/!\\ NixOS rebuild failed /!\\ \n ```'
	log="$(tail -n 8 .nixos-switch.log)"
	post_log=$'```\n\n'
	publish_on_discord "${msg}${log}${post_log}"

	grep -C 3 --color -F 'error' .nixos-switch.log
	grep -C 3 --color -F 'fail' .nixos-switch.log
	tail -n 10 .nixos-switch.log

	echo -ne "\n"

	# shellcheck disable=SC2162
	read -rp 'Open log? (y/N): ' log_confirm
	if [[ "${log_confirm}" == [yY] ]] || [[ "${log_confirm}" == [yY][eE][sS] ]]; then
		vim -R .nixos-switch.log
	fi
fi


shopt -u globstar
popd > /dev/null || exit
