{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.home-assistant;
	cfg-hass = config.services.home-assistant;
	hass-port = 8123;
	hass-ssh-key-path = "${cfg-hass.configDir}/.ssh/id_${settings.hostname}_hass";

	add-wol-dev  = (name: domain: mac: { inherit name domain mac; command = "sudo poweroff"; });
	add-wowl-dev = (name: domain: mac: { inherit name domain mac; command = "sudo eep"; });

	wol-devices  = [ (add-wol-dev  "quiss" "server.local" "f4:6d:04:99:dc:9a") ];
	wowl-devices = [ (add-wowl-dev "msi"   "host.local"   "d4:3b:04:51:45:28") ];
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
			myhome_yaml =
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
					(add-light 17 "Luce Cucina Piano Lavoro")
					(add-light 18 "Luce Cucina OVEST")
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
		];


		# Generate hass key
		services.openssh.hostKeys = [ {
			type = "ed25519";
			comment = "hass@${settings.hostname}";
			path = hass-ssh-key-path;
		} ];


		# Allow home assistant to access usb options
		systemd.services.home-assistant.serviceConfig.DeviceAllow = [ ]
		++ lib.lists.optionals (
			builtins.any (pkg: pkg != null) (
				lib.attrsets.mapAttrsToList (name: pkg: pkg) cfg.packages.usb
			)
		) [
			"char-usb rw"
			"char-usb_device rw"
			"/dev/bus/usb rw"
		];

		# Enable hass service
		services.home-assistant =
		{
			inherit (cfg) enable openFirewall;

			# Interface
			# <https://mynixos.com/nixpkgs/option/services.home-assistant.lovelaceConfig>
			lovelaceConfigWritable = true;
			configWritable = true;

			configDir = "/var/lib/hass";
			config =
			{
				# <https://www.home-assistant.io/integrations/default_config/>
				# default_config = { };


				# --- System --- #

				homeassistant = {
					name = "Burrow";
					temperature_unit = "C";
					unit_system = "metric";
				};

				automation = "!include automations.yaml";

				logger.default = "info";

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


				# --- Integrations --- #

				# bluetooth = {};
				config = {};
				history = {};
				recorder.commit_interval = 30;
				image_upload = {};
				mobile_app = {};
				# sun = { };

				# Wake on LAN
				wake_on_lan = {};
				switch = []
				++ builtins.map (
					{ name, domain, mac, ... }:
					{
						inherit mac name;
						platform = "wake_on_lan";
						host = "${name}.${domain}";
						turn_off.action = "shell_command.remote_${name}_wo_poweroff";
					}
				) (wol-devices ++ wowl-devices);

				shell_command = { }
				//
				lib.attrsets.mapAttrs' (
					name: pkg:
					{
						name = builtins.replaceStrings ["-"] ["_"] name;
						value = (
							if pkg != null
							then "${pkg}/bin/${name}"
							else "echo 'Package ${name} is not present!'; exit -1;"
						);
					}
				) cfg.packages.usb
				//
				builtins.listToAttrs (
					builtins.map (
						{ name, domain, mac, command }:
						{
							name = "remote_${name}_wo_poweroff";
							value = "${pkgs.openssh}/bin/ssh -i '${hass-ssh-key-path}' hass-agent@${name}.${domain} ${command}";
						}
					) (wol-devices ++ wowl-devices)
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

				"analytics"
				"google_translate"
				"met"
				"radio_browser"
				"shopping_list"
				"isal"

				# Default Components
				# #################### #

				# "assist_pipeline"      # Voice Assistant
				# "bluetooth"
				"config"                 # Configure and manage HAss
				# "conversation"         # Converse with Voice Assistant
				# "dhcp"                 # Discover devices through DHCP
				# "energy"               # Energy features
				"go2rtc"                 # Camera streaming proxy
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
				description = "The virtualHost";
				type = lib.types.str;
			};
		};

		packages = {
			usb = {
				usb-ports-on = lib.mkOption {
					description = "The usb-ports-on package or null";
					type = lib.types.nullOr lib.types.package;
					default = null;
				};
				usb-ports-off = lib.mkOption {
					description = "The usb-ports-off package or null";
					type = lib.types.nullOr lib.types.package;
					default = null;
				};
			};
		};

	};
}

