{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.network;
	has_items = (list: (builtins.length list) > 0);
in

{
	config =
	{
		# Fix hangups
		systemd.network.wait-online.enable = false;
		boot.initrd.systemd.network.wait-online.enable = false;

		# Let user manage network
		users.users.${settings.username}.extraGroups = [ "networkmanager" ];

		# Network settings
		networking =
		{
			hostName = settings.hostname;
			domain = "host.local";

			networkmanager.enable = true;
			wireless.enable = false; # disable wpa_supplicant.
			# dhcpcd.enable = false;

			# DNS Servers
			nameservers = [
				"193.110.81.0" # https://www.dns0.eu/it
				"185.253.5.0"  # https://www.dns0.eu/it
			];

			# Wake on Lan

			# interfaces = builtins.listToAttrs (
			# 	lib.lists.forEach cfg.wakeOnLan.enableFor (
			# 		interface:
			# 		{
			# 			name = interface;
			# 			value = { wakeOnLan.enable = true; };
			# 		}
			# 	)
			# );

			# Local DNS Records

			hosts =
			{
				"192.168.7.1"   = [ "gateway.local" ];
				# "192.168.7.2"   = [  "switch.local" ];

				# SERVERS
				# "192.168.7.3" = [     "alpha.server.local" ];
				# "192.168.7.4" = [ "alpha-ilo.server.local" ];

				# "192.168.7.5" = [     "beta.server.local" ];
				# "192.168.7.6" = [ "beta-ilo.server.local" ];

				"192.168.7.7" = [  "quiss.server.local" ];
				"192.168.7.8" = [ "jarvis.server.local" ];

				# SERVICES
				"192.168.7.16" = [ "home-assistant.service.local" ];

				# CLIENTS
				"192.168.7.32" = [  "msi.host.local" ];
				"192.168.7.33" = [ "acer.host.local" ];
			};

		};
		
		# Wake on Lan
		# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
		# `sudo ethtool -s enp4s0 wol g`

		# systemd.network = # lib.mkIf (has_items cfg.wakeOnLan.enableFor)
		# {
		# 	enable = true;

		# 	links = builtins.listToAttrs (
		# 		lib.lists.forEach cfg.wakeOnLan.enableFor (
		# 			interface:
		# 			{
		# 				name = "40-${interface}";
		# 				value = {
		# 					matchConfig.OriginalName = interface;
		# 					linkConfig.WakeOnLan = "magic";
		# 				};
		# 			}
		# 		)
		# 	);
		# };

		# environment.systemPackages =
		# let
		# 	wake-device-pkgs = lib.attrsets.mapAttrsToList (
		# 		host: mac:
		# 		pkgs.writeShellScriptBin "${host}-wake" "wakeonlan ${mac}"
		# 	) cfg.wakeOnLan.knownDevices;
		# in
		# lib.mkIf (has_items wake-device-pkgs)
		# (	
		# 	[ pkgs.wakeonlan ] ++ wake-device-pkgs
		# );
	};

	# ------------------------------------------------------------ #

	options.common.core.network =
	{
		wakeOnLan =
		{
			enableFor = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "Interfaces that should wake the computer up";
				default = [ ];
			};
			
			knownDevices = lib.mkOption {
				type = lib.types.attrsOf lib.types.str;
				description = "Devices that have WoL enabled";
				default = { };
			};
		};
	};
}
