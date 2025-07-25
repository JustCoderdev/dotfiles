{ config, lib, pkgs, dotfiles, ... }:

let
	get_conf = (hostname: mac: ip: domain: { inherit hostname mac ip domain; });
	confs = {
		switch    = get_conf "switch"    "58:97:1e:94:b7:40" "10.0.0.2" "local";

		# -------------------- #

		alpha      = get_conf "alpha"     "1c:c1:de:be:c6:c4" "10.0.0.3" "server.local";
		alpha-ilo  = get_conf "alpha-ilo" "1c:c1:de:be:c6:c6" "10.0.0.4" "server.local";

		beta       = get_conf "beta"      "30:8d:99:b2:88:df" "10.0.0.5" "server.local";
		beta-ilo   = get_conf "beta-ilo"  "30:8d:99:b2:88:dd" "10.0.0.6" "server.local";

		# quiss      = get_conf "quiss"     "f4:6d:04:99:cb:11" "10.0.0.7" "server.local";
		# jarvis     = get_conf "jarvis"    "3a:9c:e1:e5:ca:de" "10.0.0.8" "server.local";
#        ^ jarvis-br0                     "b8:27:eb:22:44:60"
	};

	get_dhcp_host = ({ hostname, mac, ip, ... }: "${mac},${hostname},${ip},infinite");
	get_ssh_forward = (
		{ ip, ... }:
		let
			last-byte = lib.lists.last (lib.strings.splitString "." ip);
		in
		{
			proto = "tcp";
			sourcePort = lib.strings.toInt "50${last-byte}22";
			destination = "${ip}:22";
		}
	);

in

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};


	# Mouse support
	environment.systemPackages = with pkgs; [ piper
	ciscoPacketTracer8 dbeaver-bin ];
	services.ratbagd.enable = true;


	# networking.interfaces."wlp3s0".ipv4.routes = [
	# 	{
	# 		address = "10.255.255.248";
	# 		prefixLength = 30;
	# 		via = "192.168.7.1";
	# 		type = "unicast";
	# 	}
	# ];


	# HASS
	# ------------------------------------------------------------ #
	# great repo <https://github.com/Mic92/dotfiles/tree/393539385b0abfc3618e886cd0bf545ac24aeb67/machines/eve/modules/home-assistant>

	systemd.tmpfiles.rules =
	let
		cfg-hass = config.services.home-assistant;

		auth_provider_homeassistant = pkgs.writeText "auth_provider.homeassistant" (
			builtins.toJSON
			{
				version = 1;
				minor_version = 1;
				key = "auth_provider.homeassistant";
				data.users =
				let
					add-user = username: password: { inherit username password; };
				in
				[
					(add-user "ryuji" "JDJiJDEyJHNxeC4zSldTR1p2Z2RYMzdSV3FKVXVtSlUvT2gvUVdaN252T2hNeThrdExHcjJWTzRHQm55")
					(add-user "perio" "JDJiJDEyJGNPVFR3OHRuTDhXM3BYRGM2bWlLdHVHL1pYSW9KT2NSVVg4UTNJdE1Kcmpwd1gzTEpMSVd5")
					(add-user "sonia" "JDJiJDEyJFY4TzY4SlJXQUVvOVRIb2JwTTV2dHVUMFZ0VEZ6dUVqdG9LSHNPd1J4ODdrT2F5cFlaMzNp")
				];
			}
		);

		core_area_registry = pkgs.writeText "core.area_registry" (
			builtins.toJSON
			{
				version = 1;
				minor_version = 8;
				key = "core.area_registry";
				data.areas =
				let
					add-area = floor_id: icon: id: name:
					{
						inherit floor_id icon id name;
						aliases = [];
						humidity_entity_id = null;
						labels = [];
						picture = null;
						temperature_entity_id = null;
						created_at = "2025-03-15T17:52:18.640366+00:00";
						modified_at = "2025-03-16T08:29:15.674415+00:00";
					};
				in
				[
					(add-area "primo_piano" "mdi:sofa"           "soggiorno"           "Salotto")
					(add-area "primo_piano" "mdi:faucet-variant" "cucina"              "Cucina")
					(add-area "primo_piano" "mdi:bed-single"     "camera_da_letto"     "Cameretta")
					(add-area "primo_piano" "mdi:bed-double"     "camera_matrimoniale" "Matrimoniale")
					(add-area "primo_piano" "mdi:bathtub"        "bagno"               "Bagno")
					(add-area "primo_piano" "mdi:outdoor-lamp"   "balcone"             "Balcone")
				];
			}
		);

		core_config = pkgs.writeText "core.config" (
			builtins.toJSON
			{
				version = 1;
				minor_version = 4;
				key = "core.config";
				data = {
					latitude = 0;
					longitude = 0;
					elevation = 0;
					radius = 0;

					unit_system_v2 = "metric";
					location_name = "Burrow";
					time_zone = "Europe/Rome";
					external_url = "https://home-assistant.foxburrow.org";
					internal_url = null;
					currency = "EUR";
					country = "IT";
					language = "en";
				};
			}
		);

		core_floor_registry = pkgs.writeText "core.floor_registry" (
			builtins.toJSON
			{
				version = 1;
				minor_version = 2;
				key = "core.floor_registry";
				data.floors = [
					{
						aliases = [];
						floor_id = "primo_piano";
						icon = null;
						level = 1;
						name = "Primo piano";
						created_at = "2025-03-16T06:36:09.377299+00:00";
						modified_at = "2025-03-16T06:36:09.377304+00:00";
					}
				];
			}
		);

		lovelace_dashboard_termostato = pkgs.writeText "lovelace.dashboard_termostato" (
			builtins.toJSON (
				builtins.fromJSON (
					builtins.readFile "${dotfiles}/nixos/hosts/msi/hass/lovelace.dashboard_termostato"
				)
			)
		);

		lovelace_dashboards = pkgs.writeText "lovelace_dashboards" (
			builtins.toJSON
			{
				version = 1;
				minor_version = 1;
				key = "lovelace_dashboards";
				data.items = [
					{
						id = "dashboard_termostato";
						show_in_sidebar = true;
						icon = "mdi:home";
						title = "Casa";
						require_admin = false;
						mode = "storage";
						url_path = "dashboard-termostato";
					}
				];
			}
		);


		myhome_yaml = pkgs.writeText "myhome.yaml" (
			builtins.readFile "${dotfiles}/nixos/hosts/msi/hass/myhome.yaml"
		);
	in
	[
#		Type Path                                                         Mode User Group Age Argmuent
		"d   ${cfg-hass.configDir}/blueprint                              0755 hass hass"

		"f   ${cfg-hass.configDir}/automations.yaml                       0755 hass hass"
		"L+  ${cfg-hass.configDir}/myhome.yaml                            0755 hass hass  -   ${myhome_yaml}"

		"L+  ${cfg-hass.configDir}/.storage/auth_provider.homeassistant   0644 hass hass  -   ${auth_provider_homeassistant}"

		"L+  ${cfg-hass.configDir}/.storage/core.area_registry            0644 hass hass  -   ${core_area_registry}"
		"L+  ${cfg-hass.configDir}/.storage/core.config                   0644 hass hass  -   ${core_config}"
		"L+  ${cfg-hass.configDir}/.storage/core.floor_registry           0644 hass hass  -   ${core_floor_registry}"

		"L+  ${cfg-hass.configDir}/.storage/lovelace_dashboards           0644 hass hass  -   ${lovelace_dashboards}"
		"L+  ${cfg-hass.configDir}/.storage/lovelace.dashboard_termostato 0644 hass hass  -   ${lovelace_dashboard_termostato}"
	];

	services.home-assistant =
	{
		enable = false;
		openFirewall = false;

		# Interface
		# <https://mynixos.com/nixpkgs/option/services.home-assistant.lovelaceConfig>
		lovelaceConfigWritable = true;
		# customLovelaceModules = [ ];
		# lovelaceConfig = { };

		configWritable = true;
		# configDir = "/var/lib/hass";
		config = {
			default_config = { };
			homeassistant = {
				name = "Burrow";
				temperature_unit = "C";
				unit_system = "metric";
			};
		};

		customComponents =
		[
			(pkgs.callPackage ../../unofficial/myhome.nix {
				OWNd-pkg = (pkgs.python313Packages.callPackage ../../unofficial/OWNd.nix {});
			})
		];

		extraComponents =
		[
			"apple_tv" # "esphome"
			"homekit"
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

			# Extra
			# #################### #

			# "assist_pipeline"      # Voice Assistant
			"bluetooth"
			# "config"               # Configure and manage HAss
			# "conversation"         # Converse with Voice Assistant
			# "dhcp"                 # Discover devices through DHCP
			# "energy"               # Energy features
			# "go2rtc"               # Camera streaming proxy
			"history"
			"homeassistant_alerts"
			# "cloud"
			"image_upload"
			"logbook"
			# "media_source"
			"mobile_app"
			"my"
			# "ssdp"
			# "stream" # Proxy live streming
			# "sun"
			# "usb"
			# "webhook"
			# "zeroconf" # Network autodiscovery
		];
	};


	# Network routing
	# src: <https://www.reddit.com/r/NixOS/comments/1i89lh2/comment/m8s1g8t/?context=3>
	# ------------------------------------------------------------ #

	# Enable kernel packet forwarding
# 	boot.kernel.sysctl = {
# 		"net.ipv4.conf.all.forwarding" = true;
# 		"net.ipv6.conf.all.forwarding" = true;
# 	};
#
# 	# Check leases here
# 	# /var/lib/dnsmasq/dnsmasq.leases
# 	services.dnsmasq = {
# 		enable = true;
# 		resolveLocalQueries = false;
# 		settings = {
# 			# dns
# 			server = [
# 				"193.110.81.0" # https://www.dns0.eu/it
# 				"185.253.5.0"  # https://www.dns0.eu/it
# 			];
#
# 			domain-needed = true;
# 			bogus-priv = true;
# 			no-resolv = true;
# 			cache-size = 1000;
#
# 			interface = "eno1";
# 			no-hosts = true;
#
# 			# dhcp
# 			dhcp-option = "option:router,10.0.0.1";
# 			dhcp-range = [ "br-lan,10.0.0.16,10.0.0.127,1h" ];
# 			dhcp-host = [ "msi,10.0.0.1" ]
# 				++ lib.attrsets.mapAttrsToList (name: value: (get_dhcp_host value)) confs;
# 		};
# 	};
#
#
#
# 	networking = {
# 		nftables.enable = true;
# 		firewall.trustedInterfaces = [ "eno1" ];
# 		networkmanager.unmanaged = [ "interface-name:eno1" ];
#
# 		# Add dns record
# 		hosts = { }
# 		// (
# 			lib.attrsets.mapAttrs' (
# 				name: value:
# 				lib.attrsets.nameValuePair (value.ip) ([ "${value.hostname}.${value.domain}" ])
# 			) confs
# 		);
#
# 		nat = {
# 			enable = true;
# 			internalIPs = [ "10.0.0.0/24" ];
# 			internalInterfaces = [ "eno1" ];
#
# 			forwardPorts = [ ]
# 			++ lib.attrsets.mapAttrsToList (name: value: (get_ssh_forward value)) confs;
#
# 			externalInterface = "wlp3s0";
# 		};
#
# 		interfaces.eno1 = {
# 			useDHCP = false;
# 			ipv4.addresses = [
# 				{
# 					address = "10.0.0.1";
# 					prefixLength = 24;
# 				}
# 			];
# 		};
# 	};
}
