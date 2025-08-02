set -e

# Check variables
if [ -z "${DOT_FILES:-}" ]; then
	echo -e "\033[31mUnknown dotfiles path\033[0m"
	echo -e "Set the DOT_FILES environmental variable in the shell first, exiting..."
	exit 1
fi

if [ -z "${USER:-}" ]; then
	echo -e "\033[31mUnknown USER variable\033[0m"
	echo -e "Set the USER environmental variable in the shell first, exiting..."
	exit 1
fi

homepath="/home/${USER}"

function ulink {
	file="$1";

	# If file exists and is link
	if [ -L "${file}" ]; then
		unlink "${file}"
		echo -e "   \033[32m[OK]\033[0m Unlinked \033[36m'${file}'\033[0m"
	fi

	# If file exists
	if [ -e "${file}" ]; then
		echo -e "\033[31m[ERROR]\033[0m File \033[36m'${file}'\033[0m is not a link"
		return 0; # Must be 0 to avoid triggering -e
	else
		echo -e " \033[33m[WARN]\033[0m File \033[36m'${file}'\033[0m does not exist"
	fi
}

echo -e "Unlinking files"
ulink "${homepath}/.config/alacritty"  # Alacritty
ulink "${homepath}/.config/clang"      # Clang
ulink "${homepath}/.config/i3"         # i3
ulink "${homepath}/.config/waybar"     # Waybar
ulink "${homepath}/.config/MangoHud"   # MangoHud

ulink "${homepath}/.clang-format"      # Clang format
ulink "${homepath}/.emacs"             # Emacs
ulink "${homepath}/.emacs.custom.el"   # Emacs
ulink "${homepath}/.emacs.extra"       # Emacs
ulink "${homepath}/.gitconfig"         # Git
ulink "${homepath}/.gitignore_global"  # Git
ulink "${homepath}/.zshrc"             # Zsh

if [ -z "${DOT_NIXOS:-}" ]; then
	echo "TODO: Fix unlinking on non nixos distro !!"
	exit 1;

	# link "${DOT_FILES}/confs/hyprland"       "${homepath}/.config/hypr"  # Hyprland
	# link "${DOT_FILES}/confs/neovim"         "${homepath}/.config/nvim"  # Nvim
	# link "${DOT_FILES}/confs/plymouth"       "/etc"         # Plymouth
fi

echo "Done mounting configs"
