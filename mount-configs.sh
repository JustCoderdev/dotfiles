#!/bin/bash

setopt -e

# Search for environment path
if [ -z "${DOT_FILES:-}" ]; then
	echo -e "\033[31mUnknown dotfiles path\033[0m"
	echo -e "Set DOT_FILES environmental variable in shell"
	exit 1
fi

configpath="/home/${USER}/.config"

function link {
	from="$1"; to="$2";

	if [ -L "${to}" ]; then
		unlink "${to}"
		echo "Unlinking '${to}'"
	fi

	if [ -e "${to}" ]; then
		echo "[ERROR] Linking '${from##/*/}' to '${to}': file exists"
	else
		if ln -snf "${from}" "${to}"; then
			echo "[ERROR] Linking '${from##/*/}' to '${to}': Ln return code ${?}"
		else
			echo "[OK] Linked '${from##/*/}' to '${to}'"
		fi
	fi
}

echo "Creating default folders :D"
mkdir -p "/home/${USER}/Developer"
mkdir -p "/home/${USER}/Developer/Github"
mkdir -p "/home/${USER}/Developer/Projects"


echo "Setting soft links <3"
link "${DOT_FILES}/alacritty"  "${configpath}"  # Alacritty
link "${DOT_FILES}/clangd"     "${configpath}"  # Clang
link "${DOT_FILES}/hypr"       "${configpath}"  # Hyprland
link "${DOT_FILES}/i3"         "${configpath}"  # i3
link "${DOT_FILES}/MangoHud"   "${configpath}"  # MangoHud
link "${DOT_FILES}/nvim"       "${configpath}"  # Nvim
link "${DOT_FILES}/waybar"     "${configpath}"  # Waybar

echo "Setting weird links ?"
link "${DOT_FILES}/clangd/.clang-format"   "${HOME}"         # Clang format
link "${DOT_FILES}/i3/scripts/bin/*"       "/usr/local/bin"  # i3
link "${DOT_FILES}/plymouth"               "/etc"            # Plymouth
link "${DOT_FILES}/zsh"                    "${HOME}/.zsh"    # Zsh
link "${DOT_FILES}/zsh/.zshrc"             "${HOME}"         # Zsh
link "${DOT_FILES}/emacs/.emacs"           "${HOME}"         # Emacs
link "${DOT_FILES}/git/.gitconfig"         "${HOME}"         # Git
link "${DOT_FILES}/git/.gitignore_global"  "${HOME}"         # Git

echo "Done ^^"
