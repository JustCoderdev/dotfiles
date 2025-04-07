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

echo -n "Creating default folders... "
mkdir -p "${homepath}/Developer"
mkdir -p "${homepath}/Developer/Github"
mkdir -p "${homepath}/Developer/Projects"
echo "Done! :D"

echo -e "Creating soft links"
link "${DOT_FILES}/confs/alacritty"      "${homepath}/.config"  # Alacritty
link "${DOT_FILES}/confs/clang"          "${homepath}/.config"  # Clang
link "${DOT_FILES}/confs/i3"             "${homepath}/.config"  # i3
link "${DOT_FILES}/confs/waybar"         "${homepath}/.config"  # Waybar

link "${DOT_FILES}/confs/clang/.clang-format"    "${homepath}"  # Clang format
link "${DOT_FILES}/confs/emacs/.emacs"           "${homepath}"  # Emacs
link "${DOT_FILES}/confs/emacs/.emacs.custom.el" "${homepath}"  # Emacs
link "${DOT_FILES}/confs/emacs/.emacs.extra"     "${homepath}"  # Emacs
link "${DOT_FILES}/confs/git/.gitconfig"         "${homepath}"  # Git
link "${DOT_FILES}/confs/git/.gitignore_global"  "${homepath}"  # Git
link "${DOT_FILES}/confs/zsh/.zshrc"             "${homepath}"  # Zsh

if [ -z "${DOT_NIXOS:-}" ]; then
	echo "TODO: Fix linking on non nixos distro !!"
	exit 1;

	# link "${DOT_FILES}/confs/hyprland"       "${homepath}/.config/hypr"  # Hyprland
	# link "${DOT_FILES}/confs/neovim"         "${homepath}/.config/nvim"  # Nvim
	# link "${DOT_FILES}/confs/plymouth"       "/etc"         # Plymouth
fi

echo "Done mounting configs"
