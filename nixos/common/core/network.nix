{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username hostname;
in

{
	config =
	{
		# Fix hangups
		systemd.network.wait-online.enable = false;
		boot.initrd.systemd.network.wait-online.enable = false;

		# Tethering
		# services.usbmuxd.enable = true;
		# environment.systemPackages = with pkgs; [ libimobiledevice ];

		# Allow stateful changes
		users.users.${username}.extraGroups = [ "networkmanager" ];


		networking =
		{
			hostName = hostname;
			domain = "lan";

			firewall = {
				enable = true;
				allowPing = true;
			};

			wireless.enable = false;      # disable wpa_supplicant.
			networkmanager.enable = true;
			# dhcpcd.enable = false;

			# DNS Servers
			nameservers =
			[
				"193.110.81.0" # https://www.dns0.eu/it
				"185.253.5.0"  # https://www.dns0.eu/it
			];

			# Local DNS Records
			hosts =
			let
				get-fqdname = (name: network: "${name}.${network}.${config.networking.domain}");
				home-network =
				{
					# NETWORK
					"192.168.7.1"   = [ (get-fqdname "gateway" "home") ];
					"192.168.7.2"   = [ (get-fqdname  "switch" "home") ];

					# SERVERS
					"192.168.7.3" = [ (get-fqdname     "alpha" "home") ];
					"192.168.7.4" = [ (get-fqdname "ilo-alpha" "home") ];
					"192.168.7.5" = [ (get-fqdname      "beta" "home") ];
					"192.168.7.6" = [ (get-fqdname  "ilo-beta" "home") ];
					"192.168.7.7" = [ (get-fqdname     "quiss" "home") ];
					"192.168.7.8" = [ (get-fqdname    "jarvis" "home") ];

					# HOSTS
					"192.168.7.33" = [ (get-fqdname "acer" "home") ];
					"192.168.7.34" = [ (get-fqdname "asus" "home") ];
				};

				flat-network =
				{
					"192.168.1.1" = [ (get-fqdname "gateway" "flat") ];
					"192.168.1.5" = [ (get-fqdname     "msi" "flat") ];
					"192.168.1.9" = [ (get-fqdname    "asus" "flat") ];
				};

				garden-network =
				{
					"10.255.250.1" = [ (get-fqdname       "msi" "garden") ];
					"10.255.250.2" = [ (get-fqdname     "quiss" "garden") ];
					"10.255.250.3" = [ (get-fqdname "iphone-tp" "garden") ];
					"10.255.250.4" = [ (get-fqdname      "asus" "garden") ];
				};
			in
			{}
			// home-network
			// flat-network
			// garden-network
			;
		};
	};
}
