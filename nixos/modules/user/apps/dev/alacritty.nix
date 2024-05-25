{ config, pkgs, settings, ... }:
let 
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	programs.alacritty.enable = true;
#	home.packages = with pkgs; [ alacritty ];

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/alacritty/alacritty.yml" = {
		source = "${dotfiles}/alacritty/alacritty.yml";
	};
}
