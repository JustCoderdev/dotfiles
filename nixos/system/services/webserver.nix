{ config, lib, settings, ... }:

let
	cfg = config.system.services.webserver;
	hostname = settings.hostname;
in

{
	config = lib.mkIf cfg.enable
	{
		networking.firewall.allowedTCPPorts = [ 80 ]; # 443 
		services.nginx = {
			enable = true;

			virtualHosts."${hostname}.host.lan" = {
				root = "/var/www/${hostname}";
				# enableACME = true;
				# forceSSL = true;
			};
		};

		systemd.tmpfiles.rules =
		let
			uname = settings.username;
		in
		[
#			Type Path                           Mode User     Group Age Argument
			"d   /var/www/${hostname}           0755 ${uname} users"
		];

		# security.acme = {
		# 	acceptTerms = true;
		# 	defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
		# };
	};

	# ------------------------------------------------------------ #

	options.system.services.webserver =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable webserver to serve files at /var/www/HOSTNAME";
			default = false;
		};
	};
}
