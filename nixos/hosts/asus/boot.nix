{ config, pkgs, ... }:

{
	#Bootloader

	# -- OLD UEFI -- #
	# boot.loader.systemd-boot.enable = true;
	# boot.loader.systemd-boot.configurationLimit = 5;
	# boot.loader.efi.canTouchEfiVariables = true;
	# -- OLD UEFI -- #

	boot.loader.grub.enable = true;
	common.core.bootloader = {
		support-efi = true;
		display-resolution = "1920x1080";
	};

	#Virtualisation

}
