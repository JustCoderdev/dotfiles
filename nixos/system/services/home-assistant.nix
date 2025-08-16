{ config, lib, pkgs, settings, dotfiles, ... }:

let
	cfg = config.system.services.home-assistant;
	cfg-hass = config.services.home-assistant;
	hass-port = 8123;

	wol-devices =
	let
		add-wol-dev = (
			name: domain: mac: 
			{ inherit name domain mac; }
		);
	in
	[
		(add-wol-dev "quiss" "server.local" "f4:6d:04:99:cb:11")
		(add-wol-dev "msi"   "host.local"   "d4:3b:04:51:45:28")
	];
in

{
	config = lib.mkIf cfg.enable
	{
		# HASS
		# ------------------------------------------------------------ #
		# great repo <https://github.com/Mic92/dotfiles/tree/393539385b0abfc3618e886cd0bf545ac24aeb67/machines/eve/modules/home-assistant>


		# Generate files
		systemd.tmpfiles.rules =
		let
			myhome_yaml = pkgs.writeText "myhome.yaml" (
				builtins.readFile "${dotfiles}/nixos/hosts/msi/hass/myhome.yaml"
			);

			myhome_nix =
			let
				id-from-name = (
					name:
					builtins.replaceStrings [" "] ["_"]
						(lib.strings.toLower name)
				);
				add-light = (
					where: name:
					lib.attrsets.nameValuePair
						(id-from-name name)
						({ inherit where name; })
				);
				add-climate = (
					zone: name:
					lib.attrsets.nameValuePair (id-from-name name) (
						{
							inherit zone name;
							heat = true;
							cool = false;
							standalone = true;
						}
					)
				);
				add-cover = add-light;
				lights =
				[
					(add-light 11 "Luce Entrata")
					(add-light 24 "Luce Corridoio")

					(add-light 12 "Luce Salotto EST")
					(add-light 13 "Luce Salotto OVEST")
					(add-light 14 "Luce Salotto SUD")
					(add-light 22 "Luce Salotto Balcone EST")
					(add-light 23 "Luce Salotto Balcone OVEST")

					(add-light 15 "Luce Cucina SUD")
					(add-light 16 "Luce Cucina EST")
					(add-light 17 "Luce Cucina OVEST")
					(add-light 18 "Luce Cucina Piano Lavoro")
					(add-light 21 "Luce Cucina Balcone")

					(add-light 31 "Luce Matrimoniale")
					(add-light 32 "Luce Matrimoniale Alto")
					(add-light 33 "Luce Matrimoniale Balcone")

					(add-light 34 "Luce Cameretta")

					(add-light 35 "Luce Bagno")
					(add-light 36 "Luce Bagno Specchio")
				];
				climates =
				[
					(add-climate 1 "Termostato Salotto")
					(add-climate 2 "Termostato Matrimoniale")
					(add-climate 3 "Termostato Cameretta")
					(add-climate 4 "Termostato Bagno")
				];
				covers =
				[
					(add-cover 41 "Tapparella Salotto OVEST 1")
					(add-cover 42 "Tapparella Salotto OVEST 2")
					(add-cover 43 "Tapparella Salotto SUD")

					(add-cover 44 "Tapparella Cucina SUD")
					(add-cover 45 "Tapparella Cucina EST")

					(add-cover 46 "Tapparella Matrimoniale")

					(add-cover 47 "Tapparella Cameretta EST")
					(add-cover 48 "Tapparella Cameretta NORD")

					(add-cover 49 "Tapparella Bagno")
				];
			in
			(
				(pkgs.formats.yaml {}).generate "myhome-nix.yaml"
				{
					hl4684 =
					{
						mac = "00:03:50:01:06:48";
						light = builtins.listToAttrs lights;
						climate = builtins.listToAttrs climates;
						cover = builtins.listToAttrs covers;
					};
				}
			);
		in
		[
#		Type Path                                   Mode User Group Age Argmuent
			"L+  ${cfg-hass.configDir}/myhome.yaml  0755 hass hass  -   ${myhome_yaml}"
			"L+  ${cfg-hass.configDir}/myhome.nix   0755 hass hass  -   ${myhome_nix}"
		];


		# Generate hass key
		users.users."hass".createHome = lib.mkForce true;
		services.openssh.hostKeys = [ {
			type = "ed25519";
			comment = "hass@${settings.hostname}";
			path = "/home/hass/.ssh/id_${settings.hostname}_hass";
		} ];


		# Enable hass service
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
				logger.logs."homeassistant.components.shell_command" = "debug";

				# bluetooth = {};
				config = {};
				history = {};
				recorder.commit_interval = 30;
				image_upload = {};
				mobile_app = {};

				wake_on_lan = {};
				switch = []
				++ builtins.map (
					{ name, domain, mac }:
					{
						inherit mac name;
						platform = "wake_on_lan";
						host = "${name}.${domain}";
						turn_off.action = "shell_command.remote_${name}_eep";
					}
				) wol-devices;

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
				}
				//
				builtins.listToAttrs (
					builtins.map (
						{ name, domain, mac }:
						{
							name = "remote_${name}_eep";
							value = "ssh hass@${name}.${domain} sudo eep";
						}
					) wol-devices
				);
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
				# "bluetooth"
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

