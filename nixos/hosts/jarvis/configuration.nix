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
			"10.0.0.6" = [ "beta-ilo..local" ];

			"10.0.0.7" = [  "quiss.server.local" ];
			# "10.0.0.8" = [ "jarvis.server.local" ];
		};

		wireless = {
			enable = lib.mkForce true;
			networks."WindTower-LTE".psk = "ext:windtower_lte_psk";
			secretsFile = settings.dotfiles_path + "/nixos/secrets/wireless.conf";
		};

		nftables.enable = false;
		networkmanager.unmanaged = [ "interface-name:wlan0" ];
#		firewall.trustedInterfaces = [ "enu1u1" ];

		interfaces = {
			wlan0.useDHCP = true;
#			enu1u1.useDHCP = false;

			# br0 -> enu1u1 -> display
#			br0 = {
#				useDHCP = false;
#				ipv4.addresses = [{
#					address = "192.168.1.25";
#					prefixLength = 24;
#				}];
#			};
		};

#		bridges.br0.interfaces = [ "enu1u1" ];
	};
}

