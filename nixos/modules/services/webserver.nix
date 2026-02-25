{ config, lib, settings, ... }:

let
	cfg = config.modules.services.webserver;
	inherit (settings) username;

	hostname = config.networking.hostName;
in

{
	config = lib.mkIf (cfg.enable)
	{
		networking.firewall.allowedTCPPorts = [ 80 ];
		services.nginx = {
			enable = true;
			virtualHosts."_".root = "/var/www/${hostname}";
		};

		systemd.tmpfiles.rules =
		[
#			Type Path                           Mode User     Group Age Argument
			"d   /var/www/${hostname}           0755 ${username} users"
		];
	};

	# ------------------------------------------------------------ #

	options.modules.services.webserver =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable webserver to serve files at /var/www/HOSTNAME";
			default = false;
		};
	};
}
