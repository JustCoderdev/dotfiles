{ settings, dotfiles_path, ... }:

let
	configpath = settings.config_path;
in
{
# programs.waybar.enable = true;

#	home.file."${configpath}/waybar" = {
#		source = "${dotfiles}/waybar";
#		recursive = true;
#	};
}
