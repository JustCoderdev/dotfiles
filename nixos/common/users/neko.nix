{ config, lib, ... }:

let
	cfg = config.common.users.neko;
in

{
	config = lib.mkIf cfg.enable
	{
		users.users."neko" =
		{
			isNormalUser = true;
			createHome = false;
			
			extraGroups = [ "monitor" ];

			# mkpasswd
			hashedPassword = "$y$j9T$UW3PUszvZt8wITQOClF221$i3nRPjte3F5FLvlgpK4H16CBa7GHe0N/q.BMmDSOTJ6";

			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6h5xWAlFFP3J0mcjUGQGaW+fKIi441VXPif3PuzTTT"
			];
		};
	};

	# ------------------------------------------------------------ #

	options.common.users.neko =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable remote stat user";
			default = true;
		};
	};
}

