{
	common.core.bootloader.grub.enable = true;
	hardware.raid.HPSmartArray.enable = true;

	fileSystems."/mnt/array-aad" = {
		device = "/dev/disk/by-id/scsi-3600508b1001c19061df1820d24075aad";
		fsType = "ext4";
		options = [ "nofail" ];
	};
}
