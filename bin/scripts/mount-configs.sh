set -e

# Check variables
if [ -z "${USER:-}" ]; then
	echo -e "\033[31mUnknown USER variable\033[0m"
	echo -e "Set the USER environmental variable in the shell first, exiting..."
	exit 1
fi

if [ -z "${DOTFILES:-}" ]; then
	echo -e "\033[31mUnknown dotfiles path\033[0m"
	echo -e "Attempting to use '/home/<user>/.config/dotfiles"
	DOTFILES="/home/$USER/.config/dotfiles"
fi

function link {
	from="$1"; from_filename="${from##/*/}";
	  to="$2";   to_filename="${3:-$from_filename}";

	# echo "----"
	# echo -e "from = '${from}\t\t from_filename = '${from_filename}'"
	# echo -e "to   = '${to}\t\t to_filename   = '${to_filename}'"

	# If file exists and is link
	if [ -L "${to}/${to_filename}" ]; then
		unlink "${to}/${to_filename}"
		# echo "Unlinking '${to}/${to_filename}'"
		echo -e " \033[33m[WARN]\033[0m Unlinked \033[36m'${to}/${to_filename}'\033[0m"
	fi

	# If file exists
	if [ -e "${to}/${to_filename}" ]; then
		echo -e "\033[31m[ERROR]\033[0m Linking \033[36m'${from_filename}'\033[0m to \033[36m'${to}/${to_filename}'\033[0m: file exists"
		return 0; # Must be 0 to avoid triggering -e
	fi

	# Link
	if ln -snf "${from}" "${to}/${to_filename}"; then
		echo -e "   \033[32m[OK]\033[0m Linked \033[36m'${from_filename}'\033[0m to \033[36m'${to}/${to_filename}'\033[0m"
	else
		echo -e "\033[31m[ERROR]\033[0m Linking \033[36m'${from_filename}'\033[0m to \033[36m'${to}/${to_filename}'\033[0m: return code ${?}"
	fi
}


echo -e "Creating soft links"

uhome="/home/${USER}"
link "${DOTFILES}/confs/modules/alacritty"      "${uhome}/.config"  # Alacritty
link "${DOTFILES}/confs/modules/clang"          "${uhome}/.config"  # Clang
link "${DOTFILES}/confs/modules/i3"             "${uhome}/.config"  # i3
link "${DOTFILES}/confs/modules/waybar"         "${uhome}/.config"  # Waybar
link "${DOTFILES}/confs/modules/mangohud"       "${uhome}/.config/MangoHud"  # MangoHud

link "${DOTFILES}/confs/modules/clang/.clang-format"    "${uhome}"  # Clang format
link "${DOTFILES}/confs/modules/emacs/.emacs"           "${uhome}"  # Emacs
link "${DOTFILES}/confs/modules/emacs/.emacs.custom.el" "${uhome}"  # Emacs
link "${DOTFILES}/confs/modules/emacs/.emacs.extra"     "${uhome}"  # Emacs
link "${DOTFILES}/confs/modules/git/.gitconfig"         "${uhome}"  # Git
link "${DOTFILES}/confs/modules/git/.gitignore_global"  "${uhome}"  # Git
link "${DOTFILES}/confs/modules/zsh/.zshrc"             "${uhome}"  # Zsh

# link "${DOTFILES}/modules/confs/hyprland"       "${uhome}/.config/hypr"  # Hyprland
# link "${DOTFILES}/modules/confs/neovim"         "${uhome}/.config/nvim"  # Nvim
# link "${DOTFILES}/modules/confs/plymouth"       "/etc"         # Plymouth

echo "Done mounting configs"
