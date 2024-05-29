{ config, lib, ... }:

{
	config = lib.mkIf config.system.gaming.enable {
		programs.gamemode.enable = true;

		# To use gamemode add to launch options
		# gamemoderun %command%
	};
}
