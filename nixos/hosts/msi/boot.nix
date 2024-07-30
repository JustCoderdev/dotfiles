{ ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation

	#Mounts
	system.nixos.tags = [ "ntfsON" ];
	boot.supportedFilesystems = [ "ntfs" ];
	fileSystems."/mnt/WDC_WD10" = {
		device = "/dev/disk/by-uuid/0EAE7AF7228F3AF1";
		fsType = "ntfs-3g";
		options = [ "defaults" "user" "rw" ];
	};
}
