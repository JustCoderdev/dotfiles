{ config, lib, pkgs, ... }:

let
	hyprland = config.system.desktop.hyprland;
in

{
	config = lib.mkIf config.system.gaming.enable {
		programs.steam = {
			enable = true;
			gamescopeSession.enable = true;

			extraCompatPackages = [ pkgs.proton-ge-bin pkgs.wine pkgs.wine-wayland ];
			#extest.enable = (lib.mkIf hyprland.enable true);
		};

		environment.defaultPackages = [ pkgs.wine pkgs.wine-wayland ];
	};
}
