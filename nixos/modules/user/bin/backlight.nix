{ pkgs, settings, ... }:
let
	dotfiles = settings.dotfiles_path;
	i3Bin_path = "${dotfiles}/i3/scripts/bin";
in
{
	environment.systemPackages = [(
		pkgs.writeShellApplication {
			name = "backlight";
			text = (builtins.readFile "${i3Bin_path}/backlight");
		}
	)];
}
