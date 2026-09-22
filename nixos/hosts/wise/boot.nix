{
	common.core.bootloader =
	{
		grub.enable = true;
		support-efi = true;
		display-resolution = "1920x1080";
	};

	fileSystems."/nix" = {
		device = "/dev/disk/by-uuid/59bc61ad-1bd0-4506-a6bc-a7a18b33c968";
		fsType = "ext4";
		neededForBoot = true;
		options = [ "noatime" ];
	};
}
