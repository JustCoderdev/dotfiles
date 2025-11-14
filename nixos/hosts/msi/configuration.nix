{ config, lib, pkgs, pkgs-unstable, settings, ... }:

let
	secrets = config.common.core.secrets;

	services = [
		"prowlarr" "bazarr" # "deluge"
		"lidarr" "radarr" "readarr" "sonarr"
		"jellyfin"
	];
in

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ]
	++ [ dbeaver-bin ]; # more packages support

	networking.hosts = {
		"192.168.1.5"   = [  "msi.host.lan" ];
		"192.168.1.8"   = [ "asus.host.lan" ];
	};

	# ------------------------------------------------------------ #

	# DDNS

	services.cloudflare-dyndns =
	{
		enable = true;
		apiTokenFile = secrets.cloudflare.api-token.path;
		domains = [
			"foxburrow.org"
			"www.foxburrow.org"
			"err.foxburrow.org"
			"immich.foxburrow.org"
		]
		++
		(
			builtins.map
				(name: "${name}.foxburrow.org")
				(services)
		);
	};

	# UDP   | TCP
	# ----- | ------
	# 137   | 22
	# 138   | 80
	# 3702  | 139
	# 5353  | 443
	# 21027 | 445
	# 22000 | 5357
	# 51820 | 22000
	# 51821 |

#	# Nginx quiss proxy

#	# Port 80 opened for acme
#	networking.firewall.allowedTCPPorts = [ 443 80 ];
#	services.nginx =
#	{
#		enable = true;
#		virtualHosts."msi.foxburrow.org" =
#		{
#			locations."/".proxyPass = "https://10.255.250.2";
#
#			forceSSL = true;
#			enableACME = true;
#		};
#	};
#
#	security.acme = {
#		acceptTerms = true;
#		defaults.email = "contact@foxburrow.org";
#	};


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

		virtualHosts =
		{
			"foxburrow.org" = (default-ssl-config) // { globalRedirect = "www.foxburrow.org"; };
			"www.foxburrow.org" = (default-ssl-config)
			// {
				locations =
				{
					"/" = { root = "/var/www/homepage/www"; tryFiles = "$uri.html $uri =404"; };
					"/assets".root = "/var/www/homepage";
				};
			};
			"err.foxburrow.org" = (default-ssl-config)
			// {
				locations =
				{
					"/" = { root = "/var/www/homepage/err"; tryFiles = "$uri.html $uri =404"; };
					"/assets".root = "/var/www/homepage";
				};
			};

			"immich.foxburrow.org" = (default-ssl-config)
			// {
				locations."^~ /" = {
					proxyPass = "https://10.255.250.2/";
					proxyWebsockets = true;
				};
			};

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

	# Configure DNS on cloudflare interface
	# <https://blog.cloudflare.com/argo-tunnels-that-live-forever/>
	# <https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/routing-to-tunnel/dns/>
	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."msi-cf" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."msi-cf".path;
			default = "http_status:404";

			originRequest.noTLSVerify = true;

			ingress =
			let
				create-rule = (
					subdomain: proto: port: path:
					{
						"${subdomain}.foxburrow.org" =
						{
							inherit path;
							service = "${proto}://127.0.0.1:${toString port}";
						};
					}
				);
			in
			{ }
			// (create-rule "msi-cf" "ssh"    22 ".*")
			// {};
		};
	};
}
