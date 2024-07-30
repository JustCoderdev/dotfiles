{ ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation

	#Mounts
	fileSystems."/mnt/WDC_WD10" = {
		device = "/dev/disk/by-uuid/54f2b0b8-0af3-485c-8fd1-40498476cc48";
		fsType = "ext4";
	};
}
