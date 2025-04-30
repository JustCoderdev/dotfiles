{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.jellyfin;
in

{
	config = lib.mkIf cfg.enable
	{
		services.jellyfin = {
			inherit (cfg) enable openFirewall group;
			dataDir   = cfg.config-dir + "/data";
			configDir = cfg.config-dir + "/config";
			logDir    = cfg.config-dir + "/log";
		};

		# PROXY

		services.nginx = lib.mkIf (cfg.proxy.enable)
		{
			enable = true;
			clientMaxBodySize = "20M";

			virtualHosts."${cfg.proxy.host}" =
			{
				locations =
				{
					"/jellyfin" = {
						proxyPass = "http://127.0.0.1:8096";
						extraConfig = ""
							+ "proxy_set_header Host $host;\n"
							+ "proxy_set_header X-Real-IP $remote_addr;\n"
							+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
							+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
							+ "proxy_set_header X-Forwarded-Host $http_host;\n"
							+ "proxy_buffering off;\n"
							+ "";
					};

					"~ ^/jellyfin/web/$" = {
						proxyPass = "http://127.0.0.1:8096";
						extraConfig = ""
							+ "proxy_set_header Host $host;\n"
							+ "proxy_set_header X-Real-IP $remote_addr;\n"
							+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
							+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
							+ "proxy_set_header X-Forwarded-Host $http_host;\n"
							+ "";
					};

					"/jellyfin/socket" = {
						proxyPass = "http://127.0.0.1:8096";
						extraConfig = ""
							+ "proxy_http_version 1.1;\n"
							+ "proxy_set_header Upgrade $http_upgrade;\n"
							+ "proxy_set_header Connection \"upgrade\";\n"
							+ "proxy_set_header Host $host;\n"
							+ "proxy_set_header X-Real-IP $remote_addr;\n"
							+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
							+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
							+ "proxy_set_header X-Forwarded-Protocol $scheme;\n"
							+ "proxy_set_header X-Forwarded-Host $http_host;\n"
							+ "";
					};
				};

				extraConfig = ""
					# + "add_header X-Frame-Options \"SAMEORIGIN\";\n"
					+ "add_header X-XSS-Protection \"1; mode=block\";\n"
					+ "add_header X-Content-Type-Options \"nosniff\";\n"
					+ "";
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.jellyfin =
	{
		enable = lib.mkEnableOption "Enable jellyfin daemon";

		openFirewall = lib.mkEnableOption "Open firewall";

		config-dir = lib.mkOption {
			type = lib.types.str;
			description = "Directory for application data";
		};

		group = lib.mkOption {
			type = lib.types.str;
			description = "The group all servarr services will be in";
			default = "maid";
		};

		proxy = {
			enable = lib.mkEnableOption "Add jellyfin to nginx location";

			mode = lib.mkOption {
				type = lib.types.enum [ "subdomain" "suburl" ];
				description = "Set the proxying mean";
				default = "suburl";
			};

			host = lib.mkOption {
				type = lib.types.str;
				description = "The virtualHost";
			};
		};
	};
}
