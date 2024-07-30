{ config, lib, pkgs, ... }:

let
	hyprland = config.system.desktop.hyprland;
in

{
	config = lib.mkIf config.system.gaming.enable {
		programs.steam = {
			enable = true;
			gamescopeSession.enable = true;

			#proton-ge-bin
			#extraCompatPackages = [  ];
			extest.enable = (lib.mkIf hyprland.enable true);
		};
	};
}
