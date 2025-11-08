{ config, lib, ... }:

let
	cfg = config.common.users.hass-agent;
in

{
	config = lib.mkIf (cfg.enable)
	{
		services.displayManager.hiddenUsers = [ "hass-agent" ];
		users.users."hass-agent" =
		{
			isNormalUser = true;
			createHome = false;

			extraGroups = [ "users" ];
			
			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhsz69l4TWZ+vbGHNr5Ec5dgEoq40bj90Wkh1wPkESt hass@jarvis"
			];
		};

		security.sudo.extraRules =
		[{
			users = [ "hass-agent" ];
			commands = [{
				command = "${config.system.path}/bin/poweroff";
				options = [ "NOPASSWD" ];
			}];
		}];
	};

	# ------------------------------------------------------------ #

	options.common.users.hass-agent =
	{
		enable = lib.mkEnableOption "home-assistant user agent";
	};
}

