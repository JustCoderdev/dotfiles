{ config, lib, ... }:

with lib;

{
	config = mkIf config.system.gaming.enable {
		programs.gamemode.enable = true;
	};
}
