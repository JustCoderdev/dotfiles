{ ... }:

{
#	# DDNS
#
#	services.cloudflare-dyndns =
#	{
#		enable = true;
#		apiTokenFile = config.common.core.secrets.cloudflare.api-token.path;
#		domains = [ "@.foxburrow.org" ];
#	};
#
#	# Master proxy
#	# <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>
#
#	networking.firewall.allowedTCPPorts = [ 443 80 ];
#	services.nginx =
#	let
#		default-ssl-config =
#		{
#			forceSSL = true;
#			enableAMCE = true;
#		};
#	in
#	{
#		enable = true;
#
#		recommendedOptimisation = true;
#		recommendedTlsSettings = true;
#		recommendedGzipSettings = true;
#		recommendedProxySettings = true;
#
#		virtualHosts =
#		{
#			    "foxburrow.org" = (default-ssl-config) // { return = "301 $scheme://www.foxburrow.org$request_uri"; };
#			"www.foxburrow.org" = (default-ssl-config) // { root = "/var/www/homepage"; };
#
#			"sonarr.foxburrow.org".locations =
#			{
#				"/" = (default-ssl-config) // { return = "301 /sonarr"; };
#				"/sonarr".proxyPass = "https://10.255.250.2/sonarr";
#			};
#		};
#	};
#
#	security.acme = {
#		acceptTerms = true;
#		defaults.email = "contact@foxburrow.org";
#	};
}
