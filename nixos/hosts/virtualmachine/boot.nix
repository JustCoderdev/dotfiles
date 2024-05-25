{ ... }:

{
	# Bootloader
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	boot.loader.grub.useOSProber = false;

	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.grub.configurationLimit = 5;

	# Virtualization
	virtualisation.virtualbox.guest.enable = true;
	virtualisation.virtualbox.guest.x11 = true;
}
