{ config, lib, settings, ... }:

let
	username = settings.username;
in

{
	config = lib.mkIf config.system.gaming.enable {
		users.users.${username}.extraGroups = [ "gamemode" ];
		programs.gamemode.enable = true;

		# To use gamemode add to launch options
		# gamemoderun %command%
	};
}
