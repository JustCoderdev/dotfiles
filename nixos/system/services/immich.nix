{ config, lib, ... }:

let
	cfg = config.system.services.immich;
in

{
	disabledModules = [ "services/web-apps/immich.nix" ];
	imports = [ 
		# "${unstable-path}/nixos/modules/services/networking/cloudflared.nix"
		../../unofficial/immich.nix
	];

	config = lib.mkIf cfg.enable
	{
		services.immich = {
			inherit (cfg) enable openFirewall group;
			mediaLocation = cfg.config-dir;
			host = "127.0.0.1";

			settings.server.externalDomain = "https://immich.foxburrow.org";
			accelerationDevices = [ "/dev/dri/renderD128" ];
			environment = {
				# List of comma-separated IPs set as trusted proxies
				"IMMICH_TRUSTED_PROXIES" = "127.0.0.1";
			};
		};

		# PROXY

		# services.nginx = lib.mkIf (cfg.proxy.enable)
		# {
		# 	enable = true;
		# 	clientMaxBodySize = "20M";

		# 	virtualHosts."immich.${cfg.proxy.host}" =
		# 	{
		# 		locations =
		# 		{
		# 			"/" = {
		# 				proxyPass = "http://127.0.0.1:2283";
		# 				extraConfig = ""
		# 					+ "proxy_set_header Host $host;\n"
		# 					+ "proxy_set_header X-Real-IP $remote_addr;\n"
		# 					+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
		# 					+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
		# 					+ "proxy_http_verion 1.1;\n"
		# 					+ "proxy_set_header   Upgrade    $http_upgrade;\n"
		# 					+ "proxy_set_header   Connection \"upgrade\";\n"
		# 					+ "proxy_redirect     off;\n"
		# 					+ "proxy_read_timeout 600s;\n"
		# 					+ "proxy_send_timeout 600s;\n"
		# 					+ "send_timeout       600s;\n"
		# 					+ "";
		# 			};
		# 		};

		# 		extraConfig = ""
		# 			+ "client_max_body_size 50000M;\n"
		# 			+ "";
		# 	};
		# };
	};

	# ------------------------------------------------------------ #

	options.system.services.immich =
	{
		enable = lib.mkEnableOption "Enable immich daemon";

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

		# proxy = {
		# 	enable = lib.mkEnableOption "Add immich to nginx location";
		# 	host = lib.mkOption {
		# 		type = lib.types.str;
		# 		description = "The virtualHost";
		# 	};
		# };
	};
}

