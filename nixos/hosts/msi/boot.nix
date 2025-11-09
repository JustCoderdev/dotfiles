{ config, pkgs, settings, ... }:

let
	inherit (settings) username;
in

{
	common.core.bootloader =
	{
		grub.enable = true;
		support-efi = true;
		display-resolution = "1920x1080";
	};

	# Mount

	fileSystems."/home/WDC_WD10" =
	{
		device = "/dev/disk/by-uuid/87de6ef7-b2ea-43ea-b574-52ca561288df";
		fsType = "ext4";
	};

	systemd.tmpfiles.rules = let
		uhome = "";
	in [
#		Type Path           Mode User                 Group Age Argument
		"d   /home/WDC_WD10 0755 ${username} users"
		"L+  /home/WDC_WD10 -    -                    -     -   /home/${username}/HDisk"
	];
}
