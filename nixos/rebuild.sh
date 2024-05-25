# Check whether you are on a different system
if [ -z "${1:-$HOST}" ]; then
	echo -e "Host not passed, defaulting to \033[32m#\033[0m"
else
	echo -e "Requested rebuild for \"\033[32m${1:-$HOST}\033[0m\". Updating flake file..."
	sed -i "s/\(hostname = \).*/\1\"${1:-$HOST}\";/" "./flake.nix"
fi

sudo nixos-rebuild switch --show-trace --flake ".#${1:-$HOST}"
