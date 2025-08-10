{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.network;
in

{
	config =
	{
		# Fix hangups
		systemd.network.wait-online.enable = false;
		boot.initrd.systemd.network.wait-online.enable = false;

		# Let user manage network
		users.users.${settings.username}.extraGroups = [ "networkmanager" ];

		# Tethering
		# services.usbmuxd.enable = true;
		# environment.systemPackages = with pkgs; [ libimobiledevice ];

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

			# Local DNS Records

			hosts =
			{
				"192.168.7.1"   = [ "gateway.local" ];
				"192.168.7.2"   = [  "switch.local" ];

				# SERVERS
				"192.168.7.3" = [     "alpha.server.local" ];
				"192.168.7.4" = [ "alpha-ilo.server.local" ];

				"192.168.7.5" = [     "beta.server.local" ];
				"192.168.7.6" = [ "beta-ilo.server.local" ];

				"192.168.7.7" = [  "quiss.server.local" ];
				"192.168.7.8" = [ "jarvis.server.local" ];

				# SERVICES
				"192.168.7.16" = [ "home-assistant.service.local" ];

				# CLIENTS
				"192.168.7.32" = [  "msi.host.local" ];
				"192.168.7.33" = [ "acer.host.local" ];
				"192.168.7.34" = [ "asus.host.local" ];
			};
		};
	};
}
