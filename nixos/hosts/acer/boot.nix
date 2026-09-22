{
	common.core =
	{
		bootloader =
		{
			grub.enable = true;
			support-efi = true;
			display-resolution = "1366x768";
		};

		hibernation =
		{
			enable = true;
			device = "/dev/disk/by-partlabel/disk-ssd-swap";
		};
	};
}
