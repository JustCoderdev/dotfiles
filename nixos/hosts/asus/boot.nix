{ lib, ... }:

{
	boot.kernelParams = [ "nosgx" ];

	# TODO: Add disko configuration
	boot.loader.grub.device = "nodev"; # ??

	common.core.bootloader =
	{
		grub.enable = true;
		support-efi = true;
		display-resolution = "1920x1080";
	};
}
