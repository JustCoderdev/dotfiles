{ ... }:

{
	boot.loader.grub.device = "/dev/sda";
	common.core.bootloader.grub.enable = true;

	hardware.raid.HPSmartArray.enable = true;
}
