{ ... }:

{
	#Bootloader
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	#boot.loader.grub.configurationLimit = 5;
	boot.loader.grub.useOSProber = false;

	#Virtualisation

	# Intel Graphics
	boot.initrd.kernelModules = [ "i915" ];
}
