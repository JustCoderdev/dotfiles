{ settings, ... }:

let
	username = settings.username;
in

{
	programs.alacritty = {
		enable = true;
	};

	# Import configuration from dotfiles
#	home.file."/home/${username}/.config/alacritty/alacritty.toml" = {
#		source = "${dotfiles}/alacritty/alacritty.toml";
#	};
}
