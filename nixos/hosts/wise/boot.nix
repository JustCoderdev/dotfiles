{ ... }:

{
	#Bootloader
	# boot.loader.grub.enable = true; # enabled by disko?
	common.core.bootloader = {
		support-efi = true;
		display-resolution = "1920x1080";
	};
}
