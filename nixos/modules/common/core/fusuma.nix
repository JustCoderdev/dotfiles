{ config, pkgs, lib, settings, ... }:

let
	dotfiles = settings.dotfiles_path;
	xfce = config.system.desktop.xfce;
	hyprland = config.system.desktop.hyprland;
	prefix = if xfce.enable then "xfce"
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
		(lib.mkIf xfce.enable pkgs.xdotool)
		(lib.mkIf hyprland.enable pkgs.ydotool)
	];
}
