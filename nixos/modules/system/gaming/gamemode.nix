{ config, lib, ... }:

with lib;

{
	config = mkIf config.system.gaming.enable {
		programs.gamemode.enable = true;

		# To use gamemode add to launch options
		# gamemoderun %command%
	};
}
