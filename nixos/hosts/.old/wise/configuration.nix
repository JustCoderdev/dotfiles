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
		domains =
		[
			"foxburrow.org"
			"www.foxburrow.org"
			"err.foxburrow.org"

			# "immich.foxburrow.org"
			# "deluge.foxburrow.org"
			# "jellyfin.foxburrow.org"
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

		reverse_proxy_headers = ""
			# + "proxy_set_header Host $host;\n"
			# + "proxy_set_header X-Real-IP $remote_addr;\n"
			# + "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
			# + "proxy_set_header X-Forwarded-Proto $scheme;\n"
			# + "proxy_set_header X-Forwarded-Protocol $scheme;\n"
			# + "proxy_set_header X-Forwarded-Host $http_host;\n"
		;
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

			# "jellyfin.foxburrow.org" = (default-ssl-config)
			# // {
			# 	locations =
			# 	let
			# 		location-cfg =
			# 		{
			# 			proxyPass = "https://10.255.250.2/jellyfin";
			# 			extraConfig  = ""
			# 				+ "proxy_set_header Host $host;\n"
			# 				+ "proxy_set_header X-Real-IP $remote_addr;\n"
			# 				+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
			# 				+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
			# 				+ "proxy_set_header X-Forwarded-Protocol $scheme;\n"
			# 				+ "proxy_set_header X-Forwarded-Host $http_host;\n"
			# 				+ "proxy_headers_hash_max_size 512;\n"
			# 				+ "proxy_headers_hash_bucket_size 128;\n"
			# 			;
			# 		};
			# 	in
			# 	{
			# 		"/".return = "301 /jellyfin";
			# 		"^~ /jellyfin" = location-cfg;
			# 		"/jellyfin/socket" = (location-cfg) // { proxyWebsockets = true; };
			# 	};
			#
			# 	extraConfig = ""
			# 		# + "add_header X-Frame-Options \"SAMEORIGIN\";\n"
			# 		+ "add_header X-XSS-Protection \"1; mode=block\";\n"
			# 		+ "add_header X-Content-Type-Options \"nosniff\";\n"
			# 		+ "proxy_ssl_verify off;\n"
			# 		+ "proxy_ssl_session_reuse off;\n"
			# 		+ "proxy_ssl_server_name on;\n"
			# 		+ "";
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

				extraConfig = "ssl_stapling off;\n";
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
								"^~ /${name}" =
								{
									proxyPass = "https://10.255.250.2/${name}";
									extraConfig = reverse_proxy_headers;
								};
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
