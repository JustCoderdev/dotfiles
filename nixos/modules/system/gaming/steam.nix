{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;

{
	config = mkIf config.system.gaming.enable {
		programs.steam = {
			enable = true;
			gamescopeSession.enable = true;

			#pkgs-unstable.proton-ge-bin
			#extraCompatPackages = [  ];
		};
	};
}
