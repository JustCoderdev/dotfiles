{ settings, ... }:

let
	dotfiles = settings.dotfiles_path;
	configpath = settings.config_path;
in
{
	programs.waybar.enable = true;

#	home.file."${configpath}/waybar" = {
#		source = "${dotfiles}/waybar";
#		recursive = true;
#	};
}
