{ pkgs-unstable, settings, ... }:

let
	inherit (settings) dotfiles_path;
	mdadmhook-url-path = dotfiles_path + "/nixos/secrets/mdadmhook.url";
	duckdns-token-path = dotfiles_path + "/nixos/secrets/duckdns.token";
	cftunnel-cred-path = dotfiles_path + "/nixos/secrets/cloudflare.cred";

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir = raid-mount + "/data";
	log-dir = raid-mount + "/.logs";
in

{
	# imports = [
	# 	../../unofficial/duckdns.nix
	# ];

	# MDADM RAID

	system.nixos.tags = [ "mdadm" ];

	# Mdadm configuration
	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	boot.swraid = {
		enable = true;
		mdadmConf = ''
ARRAY /dev/md0 metadata=1.2 UUID=2789150c:8e613590:21576ee7:a7060788
PROGRAM "curl -s -X POST -H 'content-type: application/json' -d \"{ \\\"content\\\": \\\"$(date) ERROR ''${1}: ''${2}\\\" }\" \"$(cat ${mdadmhook-url-path})\""
'';
	};

	fileSystems."${raid-mount}" = {
		device = "/dev/disk/by-uuid/3e1b8cbb-9c23-4d61-a423-65245733be57";
		fsType = "ext4";
		options = [ "nofail" ];
	};

	systemd.tmpfiles.rules = [
#		Type Path                       Mode User Group Age Argument
		"d   ${data-dir}/documents      0755 root root"
		"d   ${data-dir}/media/movie    0755 root root"
		"d   ${data-dir}/media/serie    0755 root root"
		"d   ${data-dir}/music          0755 root root"
	];

	# WAKE ON LAN

	networking.interfaces = {
		eno1.wakeOnLan.enable = true;
	};

	# TUNNEL

	# services.cloudflared = {
	# 	enable = true;
	# 	tunnels."local" = {
	# 		credentialsFile = "${cftunnel-cred-path}";
	# 		default = "http_status:404";
	# 		# ingress = {
	# 		# 	"*.domain1.com" = {
	# 		# 		service = "http://localhost:80";
	# 		# 	};
	# 		# };
	# 	};
	# };

	# DNS
	
	# services.duckdns = {
	# 	enable = true;
	# 	domains = [ "thefoxburrow" ];
	# 	tokenFile = duckdns-token-path;
	# };

	# HOST PROXY

	networking.firewall.allowedTCPPorts = [
		80   # HTTP
		443  # HTTPS

		8097 # Jellyfin
		9117 # Jackett
		8989 # Sonarr
		7878 # Radarr
	];

	services.nginx = {
		enable = true;

		# src <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>
		virtualHosts."quiss.host.local" = {
			# addSSL = true;
			# enableACME = true;
			root = "/var/www/quiss";

			locations = {
				"^~ /radarr/" = {
					proxyPass = "http://127.0.0.1:7878/";

# 					# <https://github.com/Jackett/Jackett/wiki/Reverse-Proxy>
# 					extraConfig = ""
# 						+ "proxy_http_version 1.1;\n"
# 						+ "proxy_set_header   Upgrade $http_upgrade;\n"
# 						+ "proxy_set_header   Connection keep-alive;\n"
# 						+ "proxy_cache_bypass $http_upgrade;\n"
# 						+ "proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;\n"
# 						+ "proxy_set_header   X-Forwarded-Proto $scheme;\n"
# 						+ "proxy_set_header   X-Forwarded-Host $http_host;\n"

# 						+ "proxy_redirect /UI/Dashboard /jackett/UI/Dashboard;\n"
# 						+ "rewrite /jackett/(.*) /$1 break;\n"
# 						+ "";
				};

				"^~ /sonarr/" = {
					proxyPass = "http://127.0.0.1:8989";

					extraConfig = ""
						# + "proxy_http_version 1.1;\n"
						# + "proxy_set_header   Upgrade $http_upgrade;\n"
						# + "proxy_set_header   Connection keep-alive;\n"
						# + "proxy_cache_bypass $http_upgrade;\n"
						# + "proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;\n"
						# + "proxy_set_header   X-Forwarded-Proto $scheme;\n"
						# + "proxy_set_header   X-Forwarded-Host $http_host;\n"

						# + "proxy_redirect /UI/Dashboard /jackett/UI/Dashboard;\n"
						# + "rewrite /jackett/(.*) /$1 break;\n"
						+ "";
				};

				"^~ /jackett/" = {
					proxyPass = "http://127.0.0.1:9117/";

					# <https://github.com/Jackett/Jackett/wiki/Reverse-Proxy>
					extraConfig = ""
						+ "proxy_http_version 1.1;\n"
						+ "proxy_set_header   Upgrade $http_upgrade;\n"
						+ "proxy_set_header   Connection keep-alive;\n"
						+ "proxy_cache_bypass $http_upgrade;\n"
						+ "proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;\n"
						+ "proxy_set_header   X-Forwarded-Proto $scheme;\n"
						+ "proxy_set_header   X-Forwarded-Host $http_host;\n"

						+ "proxy_redirect /UI/Dashboard /jackett/UI/Dashboard;\n"
						+ "rewrite /jackett/(.*) /$1 break;\n"
						+ "";
				};

				"^~ /jellyfin/" = {
					proxyPass = "http://127.0.0.1:8096/";

					# <https://forum.jellyfin.org/t-nginx-proxy-manager-config?pid=42446#pid42446>
					extraConfig = ""
						+ "proxy_set_header Host $host;\n"
						+ "proxy_set_header X-Real-IP $remote_addr;\n"
						+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
						+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
						+ "proxy_set_header X-Forwarded-Host $http_host;\n"
						+ "proxy_buffering off;\n"

						+ "sub_filter '/web/' '/jellyfin/web/';\n"
						+ "sub_filter '/socket' '/jellyfin/socket';\n"
						+ "sub_filter '/api/' '/jellyfin/api/';\n"
						+ "sub_filter '/touchicon' '/jellyfin/web/touchicon'; # Redireccionar iconos\n"
						+ "sub_filter_once off;\n"

						+ "rewrite /jellyfin/(.*) /$1 break;\n"
						+ "";
				};
			};

			extraConfig = ""
				+ "client_max_body_size 20M;\n"
				+ "add_header X-Content-Type-Options \"nosniff\";\n"
				+ "";
		};
	};

	# security.acme = {
	# 	acceptTerms = true;
	# 	defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
	# };

	# TORRENT TRACKER

	services.jackett = {
		package = pkgs-unstable.jackett;
		enable = true;
		
		openFirewall = false;
		port = 9117;
		dataDir = config-dir + "/jackett";
	};

	# MOVIE DOWNLOADER

	services.radarr = {
		package = pkgs-unstable.radarr;
		enable = true;

		openFirewall = false;
		dataDir = config-dir + "/radarr";
	};

	# SERIE DOWNLOADER

	services.sonarr = {
		enable = true;
		openFirewall = false;
		dataDir = config-dir + "/sonarr";
	};

	# MEDIA PLAYER

	services.jellyfin = {
		enable = true;

		# 8096/tcp is used by default for HTTP traffic. You can change this in the dashboard.
		# 8920/tcp is used by default for HTTPS traffic. You can change this in the dashboard.
		# 1900/udp is used for service auto-discovery. This is not configurable.
		# 7359/udp is also used for auto-discovery. This is not configurable.
		openFirewall = false;

		dataDir = data-dir + "/jellyfin";
		configDir = config-dir + "/jellyfin";
		logDir = log-dir + "/jellyfin";
	};
}
