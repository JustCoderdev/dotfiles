{ config, lib, ... }:

let
	cfg = config.common.users.hass-agent;
in

{
	config = lib.mkIf (cfg.enable)
	{
		users.users."hass-agent" =
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

	options.common.users.hass-agent =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable remote control by home-assistant";
			default = true;
		};
	};
}

