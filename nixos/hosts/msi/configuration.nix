{ config, lib, pkgs, ... }:

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
	# HASS DOCKER
	# ------------------------------------------------------------ #
	services.home-assistant =
	let
		# wanted-integrations = [
		# 	"apple_tv" # "esphome"
		# 	"homekit" "ping"
		# 	"rpi_power" "systemmonitor"
		# 	"uptime" "wake_on_lan"
		# ];
	in
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
		config.homeassistant = { };
		# 	name = "Burrow";
		# 	temperature_unit = "C";
		# 	unit_system = "metric";
		# };

		extraPackages = py-pkgs: with py-pkgs; [ psycopg2 ];
	# 	extraComponents = (wanted-integrations)
	# 	++ [
	# 		# Default config
	# 		# <https://www.home-assistant.io/integrations/default_config/>

	# 		# "assist_pipeline"      # Voice Assistant
	# 		"backup"               # Create and restore backups
	# 		"bluetooth"            #
	# 		"config"               # Configure and manage HAss
	# 		# "conversation"         # Converse with Voice Assistant
	# 		# "dhcp"                 # Discover devices through DHCP
	# 		# "energy"               # Energy features
	# 		# "go2rtc"               # Camera streaming proxy
	# 		"history"
	# 		"homeassistant_alerts"
	# 		# "cloud"
	# 		"image_upload"
	# 		"logbook"
	# 		# "media_source"
	# 		"mobile_app"
	# 		"my"
	# 		# "ssdp"
	# 		# "stream" # Proxy live streming
	# 		# "sun"
	# 		# "usb"
	# 		# "webhook"
	# 		# "zeroconf" # Network autodiscovery
	# 	];

	# 	# defaultIntegrations = (wanted-integrations);
	# 	customComponents =
	# 	[
	# 		# (
	# 		# 	{ lib, buildHomeAssistantComponent, fetchFromGitHub }:
	# 		# 	buildHomeAssistantComponent {
	# 		# 		owner = "anotherjulien";
	# 		# 		domain = "myhome";
	# 		# 		version = "0.9.3";

	# 		# 		src = fetchFromGithub {
	# 		# 			inherit owner;
	# 		# 			repo = domain;
	# 		# 			tag = version;
	# 		# 			hash = "";
	# 		# 		};

	# 		# 		dependencies = [
	# 		# 			"OWNd==0.7.48"
	# 		# 		];

	# 		# 		meta = with lib; {
	# 		# 			changelog = "https://github.com/anotherjulien/MyHOME/releases/tag/${version}";
	# 		# 			description = " MyHOME integration for Home-Assistant ";
	# 		# 			homepage = "https://github.com/anotherjulien/MyHOME/";
	# 		# 			license = licenses.agpl3Only;
	# 		# 		};
	# 		# 	}
	# 		# )
	# 	];
	};

	# ------------------------------------------------------------ #


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


	# Network routing
	# src: <https://www.reddit.com/r/NixOS/comments/1i89lh2/comment/m8s1g8t/?context=3>

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
