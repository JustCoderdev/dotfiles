{ config, lib, ... }:

let
	cfg = config.common.users.neko-agent;
in

{
	config = lib.mkIf (cfg.enable)
	{
		users.users."neko-agent" =
		{
			isSystemUser = true;
			group = "agent";

			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6h5xWAlFFP3J0mcjUGQGaW+fKIi441VXPif3PuzTTT"
			];
		};
	};

	# ------------------------------------------------------------ #

	options.common.users.neko-agent =
	{
		enable = lib.mkEnableOption "server-cat user agent" // { default = true; };
	};
}

