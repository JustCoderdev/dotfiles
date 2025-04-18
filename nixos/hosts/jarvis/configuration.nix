{ lib, settings, ... }:

{
	# -------------------- #

	# Disable unbuildable services
	services.printing.enable = lib.mkForce false;
	services.thermald.enable = lib.mkForce false;
	networking.networkmanager.plugins = lib.mkForce [ ];

	# Other
	hardware.enableRedistributableFirmware = true;
	nixpkgs.config.allowUnsupportedSystem = true;
	boot.tmp.cleanOnBoot = true;

	# -------------------- #

	systemd.network = {
		enable = true;

		netdevs =
		{
			# Display
			"10-br1".netdevConfig = {
				Kind = "bridge";
				Name = "br1";
			};
		};

		networks = 
		{
			"20-enu1u1" = {
				matchConfig.Name = "enu1u1";
				networkConfig.Bridge = "br1";
				linkConfig.RequiredForOnline = "enslaved";
			};

			"30-br1" = {
				matchConfig.Name = "br1";
				bridgeConfig = {};

				# address = [ "192.168.1.25/24" ];
				# networkConfig.DHCP = "no";

				address = [ "10.0.0.8/24" ];
				networkConfig.DHCP = "ipv4";

				linkConfig.RequiredForOnline = "no";
			};
		};
	};


	networking = {
		useDHCP = false;

		hosts =
		{
			"10.0.0.1"   = [ "gateway.local" ];
			"10.0.0.2"   = [  "switch.local" ];

			# SERVERS
			"10.0.0.3" = [     "alpha.server.local" ];
			"10.0.0.4" = [ "alpha-ilo.server.local" ];

			"10.0.0.5" = [     "beta.server.local" ];
			"10.0.0.6" = [ "beta-ilo.server.local" ];

			"10.0.0.7" = [  "quiss.server.local" ];
			# "10.0.0.8" = [ "jarvis.server.local" ];
		};

		wireless = {
			enable = lib.mkForce true;
			secretsFile = settings.dotfiles_path + "/nixos/secrets/wireless.conf";

			networks."WindTower-LTE".psk = "ext:windtower_lte_psk";
#			userControlled.enable = false;
			interfaces = [ "wlan0" ];
		};

		nftables.enable = false;
		networkmanager.unmanaged = [ "interface-name:wlan0" "interface-name:enu1u1" ];
		firewall.trustedInterfaces = [ "enu1u1" ];
	};
}

