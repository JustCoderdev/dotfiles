{ ... }:

{
	#Bootloader
	boot.loader.grub.enable = false;
	boot.loader.grub.device = "/dev/sda";
	#boot.loader.grub.configurationLimit = 5;
	boot.loader.grub.useOSProber = false;

	boot.loader.generic-extlinux-compatible.enable = true;
}
