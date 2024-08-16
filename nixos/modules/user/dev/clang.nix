{ config, pkgs, settings, ... }:
let
	username = settings.username;
	dotfiles = settings.dotfiles_path;
	cachepath = settings.cache_path;
in {
	# Configuration for:
	#  - clangd
	#  - clang-format

	home.packages = with pkgs; [
		clang-tools
		clang
	];

	# Import configuration from dotfiles
#	home.file."/home/${username}/.config/clangd" = {
#		source = "${dotfiles}/clangd/";
#		recursive = true;
#	};
#	home.file."/home/${username}/.clang-format" = {
#		source = "${dotfiles}/clangd/.clang-format";
#	};
}
