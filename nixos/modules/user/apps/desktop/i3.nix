{ config, pkgs, settings, ... }:
let
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	home.packages = with pkgs; [
		xorg.xbacklight
	];

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/i3" = {
		source = "${dotfiles}/i3";
		recursive = true;
	};
}
