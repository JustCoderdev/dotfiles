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

configpath="/home/${USER}/.config"

function link {
	from="$1"; from_filename="${from##/*/}";
	to="$2"; to_filename="${3:-$from_filename}";

	# echo "----"
	# echo -e "from = '${from}\t\t from_filename = '${from_filename}'"
	# echo -e "to   = '${to}\t\t to_filename   = '${to_filename}'"

	# If file exists and is link
	if [ -L "${to}/${to_filename}" ]; then
		unlink "${to}/${to_filename}"
		# echo "Unlinking '${to}/${to_filename}'"
	fi

	# If file exists
	if [ -e "${to}/${to_filename}" ]; then
		echo "[ERROR] Linking '${from_filename}' to '${to}/${to_filename}': file exists"
		return 0; # Must be 0 to avoid triggering -e
	fi

	# Link
	if ln -snf "${from}" "${to}/${to_filename}"; then
		echo "   [OK] Linked '${from_filename}' to '${to}/${to_filename}'"
	else
		echo "[ERROR] Linking '${from_filename}' to '${to}/${to_filename}': return code ${?}"
	fi
}

echo -n "Creating default folders... "
mkdir -p "/home/${USER}/Developer"
mkdir -p "/home/${USER}/Developer/Github"
mkdir -p "/home/${USER}/Developer/Projects"
echo "Done! :D"

echo -e "\nSetting soft links <3"
link "${DOT_FILES}/alacritty"  "${configpath}"  # Alacritty
link "${DOT_FILES}/clangd"     "${configpath}"  # Clang
link "${DOT_FILES}/i3"         "${configpath}"  # i3
link "${DOT_FILES}/MangoHud"   "${configpath}"  # MangoHud
link "${DOT_FILES}/waybar"     "${configpath}"  # Waybar

echo -e "\nSetting weird links ?"
link "${DOT_FILES}/clangd/.clang-format"   "/home/${USER}"          # Clang format
link "${DOT_FILES}/emacs/.emacs"           "/home/${USER}"          # Emacs
link "${DOT_FILES}/emacs/.emacs.custom.el" "/home/${USER}"          # Emacs
link "${DOT_FILES}/emacs/.emacs.extra"     "/home/${USER}"          # Emacs
link "${DOT_FILES}/git/.gitconfig"         "/home/${USER}"          # Git
link "${DOT_FILES}/git/.gitignore_global"  "/home/${USER}"          # Git

if [ -z "${DOT_NIXOS:-}" ]; then
	echo "TODO: Fix linking on non nixos distro !!"
	# link "${DOT_FILES}/hypr"               "${configpath}"  # Hyprland
	# link "${DOT_FILES}/nvim"               "${configpath}"  # Nvim
	# link "${DOT_FILES}/plymouth"           "/etc"           # Plymouth
	# link "${DOT_FILES}/zsh/.zshrc"         "/home/${USER}"  # Zsh
fi

echo "Done mounting configs ^^"
