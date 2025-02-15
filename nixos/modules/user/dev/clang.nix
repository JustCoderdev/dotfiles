{ pkgs, settings, ... }:

let
	username = settings.username;
in

{
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
