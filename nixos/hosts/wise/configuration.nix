{ config, ... }:

let
	secrets = config.common.core.secrets;

	services = [
		# "prowlarr" "bazarr"
		# "lidarr" "radarr" "readarr" "sonarr"
		"jellyfin"
	];
in

{
	# DDNS

	services.cloudflare-dyndns =
	{
		enable = true;
		apiTokenFile = secrets.cloudflare.api-token.path;
		domains = [
			"foxburrow.org"
			"www.foxburrow.org"
			"err.foxburrow.org"
			# "immich.foxburrow.org"
			# "deluge.foxburrow.org"
		]
		++
		(
			builtins.map
				(name: "${name}.foxburrow.org")
				(services)
		);
	};


	# Master proxy
	# <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>

	networking.firewall.allowedTCPPorts = [ 443 80 ];
	services.nginx =
	let
		default-ssl-config =
		{
			# onlySSL = true;
			forceSSL = true;
			enableACME = true;
		};
	in
	{
		enable = true;
		clientMaxBodySize = "50000M";

		recommendedOptimisation = true;
		recommendedTlsSettings = true;
		recommendedGzipSettings = true;
		recommendedProxySettings = true;

		# proxy_set_header X-Real-IP $remote_addr;
		# proxy_set_header X-Forwarded-For $remote_addr;

		virtualHosts =
		{
			"foxburrow.org" = (default-ssl-config) // { globalRedirect = "www.foxburrow.org"; };
			"www.foxburrow.org" = (default-ssl-config)
			// {
				locations =
				{
					"/" = { root = "/var/www/homepage/www"; tryFiles = "$uri.html $uri /index.html"; };
					"/assets".root = "/var/www/homepage";
				};
			};
			"err.foxburrow.org" = (default-ssl-config)
			// {
				locations =
				{
					"/" = { root = "/var/www/homepage/err"; tryFiles = "$uri.html $uri /404"; };
					"/assets".root = "/var/www/homepage";
				};
			};

			# "deluge.foxburrow.org" = (default-ssl-config)
			# // {
			# 	locations."^~ /" = {
			# 		proxyPass = "http://10.255.250.2:8112/";
			# 		proxyWebsockets = true;
			# 	};
			# };
			#
			# "immich.foxburrow.org" = (default-ssl-config)
			# // {
			# 	locations."^~ /" = {
			# 		proxyPass = "https://10.255.250.2/";
			# 		proxyWebsockets = true;
			# 	};
			# };

			"_" =
			let
				vhost-secrets = secrets.nginx.vhosts."_";
			in
			{
				addSSL = true;
				default = true;
				locations."/".return = "301 https://err.foxburrow.org/404";

				sslCertificate = vhost-secrets.cert.path;
				sslCertificateKey = vhost-secrets.key.path;
			};
		}
		//
		(
			builtins.listToAttrs (
				builtins.map (
					name:
					{
						name = "${name}.foxburrow.org";
						value = (default-ssl-config) // {
							locations =
							{
								"/".return = "301 /${name}";
								"^~ /${name}".proxyPass = "https://10.255.250.2/${name}";
							};
						};
					}
				) (services)
			)
		);
	};

	security.acme = {
		acceptTerms = true;
		defaults.email = "contact@foxburrow.org";
	};

	# TUNNEL

	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."wise-cf" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."wise-cf".path;
			default = "http_status:404";
			originRequest.noTLSVerify = true;
			ingress."wise-cf.foxburrow.org".service = "ssh://127.0.0.1:22";
		};
	};
}
