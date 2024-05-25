# Check whether you are on a different system

FLAKE_PATH="."

if [ -f "${FLAKE_PATH}/flake.nix" ]; then
	HOST_FLAKE=$(awk '/hostname = / {print $3}' "${FLAKE_PATH}/flake.nix")
	HOST_FLAKE=$(echo $HOST_FLAKE | sed 's/"\(.*\)";/\1/')
fi

HOST_SHELL="${HOST}"
HOST_INPUT="${1}"

# echo "HOST_FLAKE: ${HOST_FLAKE}"
# echo "HOST_SHELL: ${HOST_SHELL}"
# echo "HOST_INPUT: ${HOST_INPUT}"
# echo ""

# Check for input
if [ -z $HOST_INPUT ]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOST_SHELL}\033[0m"
else
	echo -e "Requested rebuild for \033[32m\"${HOST_INPUT}\"\033[0m"
	HOST_SHELL=$HOST_INPUT
fi

# Update flake file
if [ "${HOST_SHELL}" != "${HOST_FLAKE}" ]; then
	echo -e "Updating flake... (${HOST_FLAKE:---}) -> ($HOST_SHELL)"
	sudo sed -i "s/\(hostname = \).*/\1\"${HOST_SHELL}\";/" "${FLAKE_PATH}/flake.nix"
fi

# Rebuild system
sudo nixos-rebuild switch --show-trace --flake "${FLAKE_PATH}#${HOST_SHELL}"
