{ ... }:

{
	#Bootloader
	#boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.loader.grub.enable = true;
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.device = "nodev";
	boot.loader.grub.useOSProber = false;

	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.grub.configurationLimit = 5;

	#Virtualisation
}
