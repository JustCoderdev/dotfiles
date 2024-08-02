{ ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
#	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation

	#Mounts
	fileSystems."/home/WDC_WD10" = {
		device = "/dev/disk/by-uuid/87de6ef7-b2ea-43ea-b574-52ca561288df";
		fsType = "ext4";
	};

#	system.nixos.tags = [ "ntfsON" ];
#	boot.supportedFilesystems = [ "ntfs" ];
#	fileSystems."/mnt/WDC_WD10" = {
#		device = "/dev/disk/by-uuid/87de6ef7-b2ea-43ea-b574-52ca561288df";
#		fsType = "ntfs-3g";
#		options = [ "defaults" "user" "rw" ];
#	};
}
