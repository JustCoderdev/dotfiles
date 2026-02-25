{ config, lib, pkgs, pkgs-unstable, ... }:

let
	cfg = config.modules.services.immich;
in

{
	config = lib.mkIf cfg.enable
	{
		users.users.immich.extraGroups = [ "video" "render" ];

		services.immich = {
			inherit (cfg) enable openFirewall group;
			package = pkgs-unstable.immich;

			mediaLocation = cfg.config-dir;
			host = "127.0.0.1";

			settings = {
				ffmpeg = {
					accel = "vaapi";
					accelDecode = true;
					preset = "veryslow";
					transcode = "all";
				};
				image = {
					colorspace = "p3";
					extractEmbedded = false;
					fullsize = {
						enabled = false;
						format = "jpeg";
						quality = 80;
					};
					preview = {
						format = "jpeg";
						quality = 80;
						size = 1440;
					};
					thumbnail = {
						format = "jpeg";
						quality = 80;
						size = 250;
					};
				};
				machineLearning.urls = [ "http://127.0.0.1:3003" ];
				newVersionCheck.enabled = false;
				server = {
					externalDomain = "https://immich.foxburrow.org";
					loginPageMessage = "Ryuji's Gallery; DO NOT TOUCH";
					publicUsers = false;
				};
			};

			accelerationDevices = null;
			environment = {
				# List of comma-separated IPs set as trusted proxies
				"IMMICH_TRUSTED_PROXIES" = "127.0.0.1";
				"DB_STORAGE_TYPE" = "HDD";
				"IMMICH_LOG_LEVEL" = "verbose";
			};
		};

		# PROXY

		services.nginx = lib.mkIf (cfg.proxy.enable)
		{
			enable = true;
			clientMaxBodySize = "50000M";

			virtualHosts."${cfg.proxy.host}" =
			{
				serverAliases = cfg.proxy.aliases;
				locations =
				{
					"/" = {
						proxyPass = "http://127.0.0.1:2283";
						extraConfig = ""
							+ "proxy_set_header Host $host;\n"
							+ "proxy_set_header X-Real-IP $remote_addr;\n"
							+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
							+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
							+ "proxy_set_header   Upgrade    $http_upgrade;\n"
							+ "proxy_set_header   Connection \"upgrade\";\n"
							+ "proxy_redirect     off;\n"
							+ "proxy_read_timeout 600s;\n"
							+ "proxy_send_timeout 600s;\n"
							+ "send_timeout       600s;\n"
							+ "";
					};
				};
			};
		};
	};

	# ------------------------------------------------------------ #

	options.modules.services.immich =
	{
		enable = lib.mkEnableOption "immich daemon";

		openFirewall = lib.mkEnableOption "Open firewall";

		config-dir = lib.mkOption {
			type = lib.types.str;
			description = "Directory for application data";
		};

		group = lib.mkOption {
			type = lib.types.str;
			description = "The group all immich services will be in";
			default = "maid";
		};

		proxy = {
			enable = lib.mkEnableOption "nginx proxy location";
			host = lib.mkOption {
				type = lib.types.str;
				description = "The virtualHost";
			};
			aliases = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "The aliases of the host";
				default = [ ];
			};
		};
	};
}
