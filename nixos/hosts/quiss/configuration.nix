{ settings, ... }:

{
	imports = [
		../../modules/unofficial/duckdns.nix
	];

#	services.duckdns = {
#		enable = true;
#		domains = [ "thefoxburrow" ];
#		tokenFile = settings.dotfiles_abspath + "/nixos/secrets/duckdns.token";
#	};

	networking.firewall.allowedTCPPorts = [ 80 ];

	services.nginx = {
		enable = true;

		# src <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>
		virtualHosts = {
			"quiss.host.local" = {
#				addSSL = true;
#				enableACME = true;
#				serverAliases = [ "thefoxburrow.duckdns.org" ];
				root = "/var/www/blog";
			};
		};
	};

#	security.acme = {
#		acceptTerms = true;
#		defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
#	};
}
