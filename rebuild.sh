# Check whether you are on a different system

if [ -z $1 ]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOST}\033[0m"
	sudo nixos-rebuild switch --show-trace --flake ".#${HOST}"
else
	echo -e "Requested rebuild for \033[32m\"$1\"\033[0m"

	if [ "$1" != "$HOST" ]; then
		echo -e "Updating flake file... (${HOST}) -> ($1)"
		sudo sed -i "s/\(hostname = \).*/\1\"$1\";/" "./flake.nix"
	fi

	sudo nixos-rebuild switch --show-trace --flake ".#$1"
fi

