{ ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.grub.configurationLimit = 5;

	#Virtualisation
}
