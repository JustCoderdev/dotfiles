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

# 	boot.loader.grub.extraEntries = ''
# menuentry "Windows" {
# search --set=drive1 --fs-uuid <uuid>
# 	insmod part_gpt
# 	insmod fat
# 	set root=($drive)
# 	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
# }
# '';

	# Mount

	fileSystems =
	let
		add-fs = id: { device = "/dev/disk/by-id/${id}"; fsType = "ext4"; };
	in
	{
		"/home/WDC_WD10" = (add-fs "ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y6VYJ99E-part1");
		# "/home/KNG_SKC6" = (add-fs "ata-KINGSTON_SKC600256G_50026B7784C99483");
	};

	systemd.tmpfiles.rules = [
#		Type Path           Mode User                 Group Age Argument
		"d   /home/WDC_WD10 0755 ${username}          users"
		"L+  /home/WDC_WD10 -    -                    -     -   /home/${username}/HDisk"
		# "d   /home/KNG_SKC6 0755 ${username}          users"
		# "L+  /home/KNG_SKC6 -    -                    -     -   /home/${username}/SSDisk"
	];
}
