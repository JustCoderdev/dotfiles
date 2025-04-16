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

#	networking = {
#		useDHCP = false;

#		wireless = {
#			enable = lib.mkForce true;
#			networks."WindTower-LTE".psk = "ext:windtower_lte_psk";
#			secretsFile = settings.dotfiles_path + "/nixos/secrets/wireless.conf";
#		};

#		nftables.enable = false;
#		networkmanager.unmanaged = [ "interface-name:enu1u1" "interface-name:wlan0" ];
#		firewall.trustedInterfaces = [ "enu1u1" ];

#		interfaces = {
#			enu1u1.useDHCP = false;
#			wlan0.useDHCP = false;

#			br0.useDHCP = true;      # wlan0 -> gateway
#			br1 = {
#				useDHCP = false;
#				ipv4.addresses = [{  # enu1u1 -> display
#					address = "192.168.1.25";
#					prefixLength = 24;
#				}];
#			};
#		};

#		bridges = {
#			br0.interfaces = [ "wlan0" ];
#			br1.interfaces = [ "enu1u1" ];
#		};
#	};
}

