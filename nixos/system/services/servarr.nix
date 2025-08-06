{ config, lib, pkgs-unstable, ... }:

let
	cfg = config.system.services.servarr;
in

{
	config =
	let
		get-service-options = (
			service:
			{
				inherit (cfg) openFirewall group;
				inherit (cfg.apps."${service}") enable;
				dataDir = cfg.config-root-dir + "/${service}";
			}
		);
	in
	lib.mkIf cfg.enable
	{
		users.groups."${cfg.group}" = { };

		# Torrent Tracker and Indexer
		unofficial.services.prowlarr = get-service-options "prowlarr";

		services =
		{
			# Applications
			lidarr  = get-service-options "lidarr";  # Music
			radarr  = (get-service-options "radarr") // { package = pkgs-unstable.radarr; }; # Movies
			readarr = get-service-options "readarr"; # Books
			sonarr  = get-service-options "sonarr";  # Serie
	
			# Management
			bazarr = {
				inherit (cfg) openFirewall group;
				inherit (cfg.apps.bazarr) enable;
			};
			deluge = let
				deluge-options = get-service-options "deluge";
			in (deluge-options) // {
				# hack until baseurl bug gets fixed
				openFirewall = lib.mkForce true;

				declarative = true;
				authFile = "${deluge-options.dataDir}/auth";
				config = {
					"new_release_check" = false;

					"download_location" = cfg.shared-downloads-dir;
					"plugins_location" = "${deluge-options.dataDir}/plugins";
					"enabled_plugins" = [ "Label" "Stats" ];
					"allow_remote" = true;

					"max_active_seeding" = 0;
					"max_active_downloading" = 20;
					"max_active_limit" = 30;
					"max_connections_global" = 100;
				};

				web = {
					enable = true;
					port = 8112;

					# hack until baseurl bug gets fixed
					openFirewall = true;
					# inherit (cfg) openFirewall;
				};
			};
		};

		# PROXY
		# <https://wiki.servarr.com/en/readarr/installation/reverse-proxy>

		services.nginx = lib.mkIf (cfg.proxy.enable)
		{
			enable = true;
			clientMaxBodySize = lib.mkOverride 990 "20M";

			virtualHosts."${cfg.proxy.host}" =
			{
				locations = builtins.listToAttrs (
					builtins.map (
						{ name, port }:
						{
							name = "^~ /${name}";
							value = {
								proxyPass = "http://127.0.0.1:${toString port}";
								extraConfig = ""
									+ "proxy_set_header Host $host;\n"
									+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
									+ "proxy_set_header X-Forwarded-Host $host;\n"
									+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
									+ "proxy_redirect off;\n"
									+ "proxy_http_version 1.1;\n"
									+ "proxy_set_header Upgrade $http_upgrade;\n"
									+ "proxy_set_header Connection $http_connection;\n"
									+ "";
							};
						}
					) (
						builtins.filter ({ name, ... }: cfg.apps."${name}".enable)
						[
							{ name = "bazarr";   port = 6767; }
							{ name = "prowlarr"; port = 9696; }
							# -------------------- #
							{ name = "lidarr";   port = 8686; }
							{ name = "radarr";   port = 7878; }
							{ name = "readarr";  port = 8787; }
							{ name = "sonarr";   port = 8989; }
						]
					)
				);

				extraConfig = ""
					+ "add_header X-Frame-Options \"SAMEORIGIN\";\n"
					+ "large_client_header_buffers 4 16k;\n"
					+ "";
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.servarr =
	{
		enable = lib.mkEnableOption "Enable servarr suite";

		openFirewall = lib.mkEnableOption "Open firewall for all services";

		proxy = {
			enable = lib.mkEnableOption "Add nginx locations for each active services";
			host = lib.mkOption {
				type = lib.types.str;
				description = "The virtualHost";
			};
		};

		group = lib.mkOption {
			type = lib.types.str;
			description = "The group all servarr services will be in";
			default = "maid";
		};

		shared-downloads-dir = lib.mkOption {
			type = lib.types.str;
			description = "downloads directory path";
		};

		config-root-dir = lib.mkOption {
			type = lib.types.str;
			description = "Root directory for application data";
		};

		apps = {
			deluge.enable = lib.mkEnableOption "Enable deluge";
			prowlarr.enable = lib.mkEnableOption "Enable prowlarr";
			bazarr.enable = lib.mkEnableOption "Enable bazarr";
			# -------------------- #
			lidarr.enable = lib.mkEnableOption "Enable lidarr";
			radarr.enable = lib.mkEnableOption "Enable radarr";
			readarr.enable = lib.mkEnableOption "Enable readarr";
			sonarr.enable = lib.mkEnableOption "Enable sonarr";
		};
	};
}
