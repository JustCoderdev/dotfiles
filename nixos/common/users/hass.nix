{ config, lib, ... }:

let
	cfg = config.common.users.hass;
	cfg-hass = config.system.services.home-assistant;
in

{
	config = lib.mkIf (cfg.enable && !cfg-hass.enable)
	{
		users.users."hass" =
		{
			isNormalUser = true;
			createHome = false;

			extraGroups = [ "users" ];
			
			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhsz69l4TWZ+vbGHNr5Ec5dgEoq40bj90Wkh1wPkESt hass@jarvis"
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

