{ lib, ... }:

{
	#Bootloader
	# boot.loader.grub.enable = true; # enabled by disk?
	# boot.loader.grub.devices = lib.mkForce [ "nodev" ]; # "/dev/mmcblk0p1"
	common.core.bootloader = {
		support-efi = true;
		display-resolution = "1920x1080";
	};
}
