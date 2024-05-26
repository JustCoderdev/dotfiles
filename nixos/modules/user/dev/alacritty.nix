{ settings, ... }:

let
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in

{
	programs.alacritty.enable = true;

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/alacritty" = {
		source = "${dotfiles}/alacritty/";
		recursive = true;
	};
}
