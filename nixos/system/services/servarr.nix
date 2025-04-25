{ config, lib, pkgs-unstable, ... }:

let
	cfg = config.system.services.servarr;


	services = [
		{ name = "lidarr";   port = 8686; }
		{ name = "radarr";   port = 7878; }
		{ name = "readarr";  port = 8787; }
		{ name = "sonarr";   port = 8989; }
	];

	all-services = (services) ++ [ { name = "prowlarr"; port = 9696; } ];
in

{
	imports =
	[
		../../unofficial/prowlarr.nix
	];

	# ------------------------------------------------------------ #

	config =
	let
		get-service-options = (
			service:
			{
				inherit (cfg) openFirewall group;
				inherit (cfg.apps."${service}") enable;
				dataDir = cfg.data-root + "/${service}";
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
			lidarr  = get-service-options "lidarr";  # Music
			radarr  = (get-service-options "radarr") // { package = pkgs-unstable.radarr; }; # Movies
			readarr = get-service-options "readarr"; # Books
			sonarr  = get-service-options "sonarr";  # Serie
		};

		# PROXY

		services.nginx =
		let
			# <https://wiki.servarr.com/en/readarr/installation/reverse-proxy>
			default-extra-config = ""
				+"proxy_set_header Host $host;\n"
				+"proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
				+"proxy_set_header X-Forwarded-Host $host;\n"
				+"proxy_set_header X-Forwarded-Proto $scheme;\n"
				+"proxy_redirect off;\n"
				+"proxy_http_version 1.1;\n"
				+"proxy_set_header Upgrade $http_upgrade;\n"
				+"proxy_set_header Connection $http_connection;\n"
				+ "";
		in
		{
			enable = cfg.proxy.enable;
			virtualHosts."${cfg.proxy.host}".locations = { }
			//
			builtins.listToAttrs (
				builtins.map (
					{ name, port }:
					{
						name = "^~ /${name}";
						value = {
							proxyPass = "http://127.0.0.1:${toString port}";
							extraConfig = default-extra-config;
						};
					}
				) (
					builtins.filter ({ name, ... }: cfg.apps."${name}".enable) services
				)
				# ++
				# builtins.map (
				# 	{ name, port }:
				# 	{
				# 		name = "^~ /${name}/api";
				# 		value = {
				# 			proxyPass = "http://127.0.0.1:${toString port}";
				# 			extraConfig = "auth_basic off;\n";
				# 		};
				# 	}
				# ) (
				# 	builtins.filter ({ name, ... }: cfg.apps."${name}".enable) services
				# )
			)
			//
			{
				"/prowlarr" = {
					proxyPass = "http://127.0.0.1:9696";
					extraConfig = default-extra-config;
				};

				# "~ /prowlarr(/[0-9]+)?/api" = {
				# 	proxyPass = "http://127.0.0.1:9696";
				# 	extraConfig = "auth_basic off;\n";
				# };
			};
		};

		# AUTOCONFIGURATION SERVICE

		# systemd.services.configure-servarr-stack =
		# let
		# 	enabled-services = builtins.filter ({ name, ... }: cfg.apps."${name}".enable) all-services;
		# 	enabled-services-names = builtins.map ({ name, ... }: "${name}.service") enabled-services;
		# in
		# {
		# 	description = "Configure servarr services";

		# 	after = (enabled-services-names) ++ [ "network.target" ];
		# 	requires = (enabled-services-names) ++ [ "network.target" ];

		# 	serviceConfig.Type = "oneshot";
		# 	script = ''
# echo smash
# echo smash | systemd-cat
# '';
		# };


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

		data-root = lib.mkOption {
			type = lib.types.str;
			description = "Data root";
		};

		apps = {
			prowlarr.enable = lib.mkEnableOption "Enable prowlarr";
			# -------------------- #
			lidarr.enable = lib.mkEnableOption "Enable lidarr";
			radarr.enable = lib.mkEnableOption "Enable radarr";
			readarr.enable = lib.mkEnableOption "Enable readarr";
			sonarr.enable = lib.mkEnableOption "Enable sonarr";
		};
	};
}
