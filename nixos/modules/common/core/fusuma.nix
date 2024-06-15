{ config, pkgs, lib, settings, ... }:

let
	dotfiles = settings.dotfiles_path;
	i3 = config.system.desktop.xfce;
	hyprland = config.system.desktop.hyprland;
	prefix = if i3.enable then "i3"
		else if hyprland.enable then "hyprland"
		else abort "Fusuma: no desktop environment enabled";
in

{
	services.fusuma = {
		enable = true;
		settings = (builtins.readFile
			 "${dotfiles}/fusuma/${prefix}_config.yml");
	};

	environment.systemPackages = [
		(lib.mkIf i3.enable pkgs.xdotool)
		(lib.mkIf hyprland.enable pkgs.ydotool)
	];
}
