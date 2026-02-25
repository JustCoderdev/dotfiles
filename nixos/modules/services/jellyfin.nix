{ config, lib, pkgs, settings, ... }:

let
	cfg = config.modules.services.jellyfin;
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

		# Check if it works `nix-shell -p libva-utils --run vainfo`
		users.users.jellyfin.extraGroups = [ "render" "video" ];
		hardware.graphics.extraPackages = with pkgs; [
			vaapiVdpau
			libvdpau-va-gl
		];

		# PROXY

		services.nginx = lib.mkIf (cfg.proxy.enable)
		{
			enable = true;
			clientMaxBodySize = lib.mkDefault "20M";

			virtualHosts."${cfg.proxy.host}" =
			{
				serverAliases = cfg.proxy.aliases;
				locations =
				let
					reverse_proxy_headers = ""
						+ "proxy_set_header Host $host;\n"
						+ "proxy_set_header X-Real-IP $remote_addr;\n"
						+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
						+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
						+ "proxy_set_header X-Forwarded-Protocol $scheme;\n"
						+ "proxy_set_header X-Forwarded-Host $http_host;\n"
					;

					proxyPass = "http://127.0.0.1:8096";
					extraConfig = ""
						+ reverse_proxy_headers
						+ "proxy_buffering off;\n"
					;
				in
				{
					"/jellyfin" = { inherit proxyPass extraConfig; };
					"~ ^/jellyfin/web/$" = { inherit proxyPass extraConfig; };
					"/jellyfin/socket" = {
						inherit proxyPass;
						extraConfig = reverse_proxy_headers;
						proxyWebsockets = true;
					};
				};


				extraConfig = ""
					# + "add_header X-Frame-Options \"SAMEORIGIN\";\n"
					+ "add_header X-XSS-Protection \"1; mode=block\";\n"
					+ "add_header X-Content-Type-Options \"nosniff\";\n"
					+ "access_log /var/log/nginx/access.log stripsecrets;\n"
				;
			};

			commonHttpConfig = ""
				+ "log_format stripsecrets '$remote_addr $host - $remote_user [$time_local] '\n"
				+ "'\"$secretfilter\" $status $body_bytes_sent '\n"
				+ "'$request_length $request_time $upstream_response_time '\n"
				+ "'\"$http_referer\" \"$http_user_agent\"';\n"
				+ "map $request $secretfilter {\n"
				+     "~*^(?<prefix1>.*[\\?&]api_key=)([^&]*)(?<suffix1>.*)$  \"\${prefix1}***$suffix1\";\n"
				+     "~*^(?<prefix1>.*[\\?&]ApiKey=)([^&]*)(?<suffix1>.*)$  \"\${prefix1}***$suffix1\";\n"
				+     "default                                               $request;\n"
				+ "}\n"
			;
		};
	};

	# ------------------------------------------------------------ #

	options.modules.services.jellyfin =
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
