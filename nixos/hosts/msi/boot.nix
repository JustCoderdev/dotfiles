{ pkgs, settings, ... }:

let
	inherit (settings) username;
in

{
	boot.kernelParams = [ "nosgx" ];

	common.core.bootloader =
	{
		grub.enable = true;
		support-efi = true;
		display-resolution = "1920x1080";
	};

	boot.loader.grub.extraEntries = ''
menuentry "Windows" {
search --set=drive1 --fs-uuid F4AE-D825
	insmod part_gpt
	insmod fat
	set root=($drive1)
	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
'';

	# Mount

	fileSystems."/home/WDC_WD10" =
	{
		device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y6VYJ99E-part1";
		fsType = "ext4";
	};

	systemd.tmpfiles.rules = [
#		Type Path           Mode User Group Age Argument
		"d   /home/WDC_WD10 0775 root users"
		"L+  /home/WDC_WD10 -    -    -     -   /home/${username}/HDisk"
	];
}
