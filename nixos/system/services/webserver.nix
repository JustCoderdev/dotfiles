{ config, lib, settings, ... }:

let
	cfg = config.system.services.webserver;
	hostname = settings.hostname;
in

{
	config = lib.mkIf cfg.enable {

		networking.firewall.allowedTCPPorts = [ 80 443 ];
		services.nginx = {
			enable = true;

			virtualHosts."${hostname}.host.local" = {
				root = "/var/www/${hostname}";
				# enableACME = true;
				# forceSSL = true;
			};
		};

		# security.acme = {
		# 	acceptTerms = true;
		# 	defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
		# };
	};
}
