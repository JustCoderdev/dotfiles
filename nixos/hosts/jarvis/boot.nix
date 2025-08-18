{ lib, ... }:

{
	#Bootloader
	boot.loader.grub.enable = false;
	boot.loader.grub.device = "/dev/mmcblk0p1";
	#boot.loader.grub.configurationLimit = 5;
	boot.loader.grub.useOSProber = false;

	boot.loader.generic-extlinux-compatible.enable = true;

	swapDevices = [ { device = "/swapfile"; size = 1024; } ];

	# -------------------- #

	# Disable unbuildable services
	services.printing.enable = lib.mkForce false;
	services.thermald.enable = lib.mkForce false;
	networking.networkmanager.plugins = lib.mkForce [ ];

	# Other
	hardware.enableRedistributableFirmware = true;
	nixpkgs.config.allowUnsupportedSystem = true;

	# -------------------- #
}
