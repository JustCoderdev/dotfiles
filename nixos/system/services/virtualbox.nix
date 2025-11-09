{ config, lib, settings, ... }:

let
	inherit (settings) username;

	cfg = config.system.services.virtualbox;
in

{
	config = lib.mkIf cfg.enable
	{
		virtualisation.virtualbox.host = {
			enable = true;
			enableExtensionPack = true;
		};

		users.users.${username}.extraGroups = [ "vboxusers" ];
	};

	# ------------------------------------------------------------ #

	options.system.services.virtualbox =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable virtualbox daemon";
			default = false;
		};
	};
}
