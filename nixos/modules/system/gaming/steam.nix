{ config, lib, pkgs, ... }:

with lib;

{
	config = mkIf config.system.gaming.enable {
		programs.steam = {
			enable = true;
			gamescopeSession.enable = true;

			#proton-ge-bin
			#extraCompatPackages = [  ];
		};
	};
}
