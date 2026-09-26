{ ... }:

{
	boot.kernelParams = [ "nosgx" ];

	# # TODO: Add disko configuration
	# boot.loader.grub.device = "nodev"; # ??

	common.core =
	{
		bootloader =
		{
			grub.enable = true;
			support-efi = true;
			display-resolution = "1920x1080";
		};

		hibernation =
		{
			enable = true;
			device = "/dev/disk/by-partlabel/disk-nvme-29fc-swap";
		};
	};
}
