{ ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation

	#Mounts
#	fileSystems."/mnt/WDC_WD10" = {
#		device = "/dev/disk/by-uuid/2a9ccfda-3e0f-410c-9577-b7b2e15e3426";
#		fsType = "auto";
#		options = [ "defaults" "user" "rw" ];
#	};
}
