{ config, lib, ... }:

let
	cfg = config.common.users.hass;
in

{
	config = lib.mkIf cfg.enable
	{
		users.users."hass" =
		{
			isNormalUser = true;
			createHome = false;

			extraGroups = [ "users" ];
			
			openssh.authorizedKeys.keys = [

			];
		};
	};

	# ------------------------------------------------------------ #

	options.common.users.hass =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable remote control by home-assistant";
			default = true;
		};
	};
}

