{ ... }:

{
	# Bootloader
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	boot.loader.grub.useOSProber = false;

	# Virtualization
	virtualisation.virtualbox.guest.enable = true;
	virtualisation.virtualbox.guest.x11 = true;
}
