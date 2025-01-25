{ ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation


	# Nvidia drm support
	boot.kernelParams = [
		"nosgx"
		"snd-intel-dspcfg.dsp_driver=1"
		"nvidia-drm.fbdev=1" /* ls /dev/dri - dmesg | grep drm */
	];

	#Mounts
	fileSystems."/home/WDC_WD10" = {
		device = "/dev/disk/by-uuid/87de6ef7-b2ea-43ea-b574-52ca561288df";
		fsType = "ext4";
	};
}
