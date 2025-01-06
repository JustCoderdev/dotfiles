{ config, ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation

	# Intel Graphics
	boot.kernelModules = [ "i915" ];
}
