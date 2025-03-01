{ config, lib, ... }:

let
	cfg = config.common.users.neko;
	titleCase = text: lib.concatStrings [
		(lib.toUpper (builtins.substring 0 1 text))
		(builtins.substring 1 (builtins.stringLength text) text)
	];

	uname = "neko";
in

{
	config = lib.mkIf cfg.enable {
		users.users.${uname} = {
			name = uname;
			description = (titleCase uname);

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
}

