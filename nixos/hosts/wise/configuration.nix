{ ... }:

{
	# DDNS

	services.cloudflare-dyndns =
	{
		enable = true;
		apiTokenFile = config.common.core.secrets.cloudflare.api-token.path;
		domains = [ "@.foxburrow.org" ];
	};

	# Master proxy
	# <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>

	networking.firewall.allowedTCPPorts = [ 443 80 ];
	services.nginx =
	{
		enable = true;
		virtualHosts = {
			"foxburrow.org" =
			{
			};

			"www.foxburrow.org" =
			{
				locations = {
					"/".proxyPass = "https://10.255.250.2";

					"^~ /home/" = {
						root = data-dir + "/homepage";
						index = "index.html";
					};

				# addSSL = true;
				forceSSL = true;
				sslCertificate = vhost-secrets.cert.path;
				sslCertificateKey = vhost-secrets.key.path;
			};

			"foxburrow.org" =
			let
				vhost-secrets = secrets.nginx.vhosts."${proxy.host}";
			in
			{
				locations."/".proxyPass = "https://10.255.250.2";

				# forceSSL = true;
				addSSL = true;
				sslCertificate = vhost-secrets.cert.path;
				sslCertificateKey = vhost-secrets.key.path;
			};
		};
	};

	security.acme = {
		acceptTerms = true;
		defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
	};

}
