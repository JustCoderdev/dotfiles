{ config, lib, pkgs, ... }:

{
	config = lib.mkIf config.system.gaming.enable {
		programs.steam = {
			enable = true;
			gamescopeSession.enable = true;

			#proton-ge-bin
			#extraCompatPackages = [  ];
		};
	};
}
