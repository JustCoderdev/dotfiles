#!/bin/bash

# Search for environment path
if [ -z "${DOT_FILES:-}" ]; then
	echo -e "\033[31mUnknown dotfiles path\033[0m"
	echo -e "Set DOT_FILES environmental variable in shell"
	exit 1
fi

configpath="/home/${USER}/.config"

echo "Creating default folders :D"
mkdir "/home/${USER}/Developer"
mkdir "/home/${USER}/Developer/Github"
mkdir "/home/${USER}/Developer/Projects"

echo "Setting soft links <3"
ln -s "${DOT_FILES}/alacritty"  "${configpath}"  # Alacritty
ln -s "${DOT_FILES}/clangd"     "${configpath}"  # Clang
ln -s "${DOT_FILES}/hypr"       "${configpath}"  # Hyprland
ln -s "${DOT_FILES}/i3"         "${configpath}"  # i3
ln -s "${DOT_FILES}/MangoHud"   "${configpath}"  # MangoHud
ln -s "${DOT_FILES}/nvim"       "${configpath}"  # Nvim
ln -s "${DOT_FILES}/waybar"     "${configpath}"  # Waybar
ln -s "${DOT_FILES}/emacs"      "${configpath}"  # Emacs

echo "Setting weird links ?"
ln -s "${DOT_FILES}/clangd/.clang-format"  "${HOME}"         # Clang format
ln -s "${DOT_FILES}/i3/scripts/bin/*"      "/usr/local/bin"  # i3
ln -s "${DOT_FILES}/plymouth"              "/etc"            # Plymouth
ln -s "${DOT_FILES}/zsh"                   "${HOME}/.zsh"    # Zsh
ln -s "${DOT_FILES}/zsh/.zshrc"            "${HOME}"         # Zsh
