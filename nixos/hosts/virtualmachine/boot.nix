{ ... }:

{
	# Bootloader
	boot.loader.grub = {
		enable = true;
		device = "/dev/sda";
		useOSProber = true;
	};

	# Virtualization
	virtualisation.virtualbox.guest = {
		enable = true;
		x11 = true;
	};
}
