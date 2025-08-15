{ config, lib, pkgs, settings, dotfiles, ... }:

let
	cfg = config.system.services.home-assistant;
	cfg-hass = config.services.home-assistant;
	hass-port = 8123;
in

{
	config = lib.mkIf cfg.enable
	{
		# HASS
		# ------------------------------------------------------------ #
		# great repo <https://github.com/Mic92/dotfiles/tree/393539385b0abfc3618e886cd0bf545ac24aeb67/machines/eve/modules/home-assistant>

		systemd.tmpfiles.rules =
		let
			myhome_yaml = pkgs.writeText "myhome.yaml" (
				builtins.readFile "${dotfiles}/nixos/hosts/msi/hass/myhome.yaml"
			);
		in
		[
#		Type Path                                                         Mode User Group Age Argmuent
			"L+  ${cfg-hass.configDir}/myhome.yaml                            0755 hass hass  -   ${myhome_yaml}"
		];

		services.home-assistant =
		{
			inherit (cfg) enable openFirewall;

			# Interface
			# <https://mynixos.com/nixpkgs/option/services.home-assistant.lovelaceConfig>
			lovelaceConfigWritable = true;
			configWritable = true;

			# configDir = "/var/lib/hass";

			config = {
				# <https://www.home-assistant.io/integrations/default_config/>
				# default_config = { };

				automation = "!include automations.yaml";

				bluetooth = {};
				config = {};
				history = {};
				recorder.commit_interval = 30;
				image_upload = {};
				mobile_app = {};

				homeassistant = {
					name = "Burrow";
					temperature_unit = "C";
					unit_system = "metric";
				};

				http = {
					server_host = (
						if (cfg.openFirewall)
						then [ "0.0.0.0"   "::"  ]
						else [ "127.0.0.1" "::1" ]
					);
					server_port = hass-port;
					trusted_proxies = lib.mkIf (cfg.proxy.enable) [ "127.0.0.1" ];
					use_x_forwarded_for = cfg.proxy.enable;
				};

				shell_command = {
					usb_ports_on  = "sudo usb-ports-on";
					usb_ports_off = "sudo usb-ports-off";
				};
			};

			customComponents =
			[
				(pkgs.callPackage ../../unofficial/pkgs/myhome.nix {
					OWNd-pkg = (pkgs.python313Packages.callPackage ../../unofficial/pkgs/OWNd.nix {});
				})
			];

			extraComponents =
			[
				"ping"
				"rpi_power"
				"systemmonitor"
				"uptime"
				"wake_on_lan"

				# Required
				# #################### #

#				"analytics"
#				"google_translate"
#				"met"
#				"radio_browser"
#				"shopping_list"

#				"isal"

				# Default Components
				# #################### #

				# "assist_pipeline"      # Voice Assistant
				"bluetooth"
				"config"                 # Configure and manage HAss
				# "conversation"         # Converse with Voice Assistant
				# "dhcp"                 # Discover devices through DHCP
				# "energy"               # Energy features
				# "go2rtc"               # Camera streaming proxy
				"history"
				"recorder"
				# "homeassistant_alerts"
				# "cloud"
				"image_upload"
				"logbook"
				"mobile_app"
			];
		};

		# PROXY

		services.nginx = lib.mkIf (cfg.proxy.enable)
		{
			enable = true;
			virtualHosts."${cfg.proxy.host}" =
			{
				locations."/" = {
					proxyPass = "http://127.0.0.1:${toString hass-port}";
					extraConfig = ""
						+ "proxy_set_header Host $host;\n"
						+ "proxy_redirect http:// https://;\n"
						+ "proxy_http_version 1.1;\n"
						+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
						+ "proxy_set_header Upgrade $http_upgrade;\n"
						+ "proxy_set_header Connection $connection_upgrade;\n"
						+ "";
				};

				extraConfig = ""
					+ "proxy_buffering off;\n"
					+ "";
			};
		};

		assertions = [
			{
				message = "Cannot enable home-assistant and immich under proxy because they both use the same base url path (/)";
				assertion = !config.system.services.immich.enable;
			}
		];
		
	};

	# ------------------------------------------------------------ #

	options.system.services.home-assistant =
	{
		enable = lib.mkEnableOption "Enable customised home assistant options";
		openFirewall = lib.mkEnableOption "Open firewall for home assistant";
		proxy = {
			enable = lib.mkEnableOption "Add nginx locations for home assistant";
			host = lib.mkOption {
				type = lib.types.str;
				description = "The virtualHost";
			};
		};

	};
}

