let
	optionalattrs = (
		expr: set:
		if expr then set else { }
	);

	create-fs = (
		format: mountpoint:
		{
			type = "filesystem";
			inherit format mountpoint;
		}
	);

	create-pt = (
		size: type: content:
		{ inherit size; }
		// optionalattrs (type != null) { inherit type; }
		// optionalattrs (content != null) { inherit content; }
	);

	# Disk partitions

	data-raid-partition = (create-pt "100%"  null ({ name = "md0data"; type = "mdraid"; }));
	storageconfig =
	{
		type = "mdadm";
		level = 1;

		content =
		{
			type = "gpt";
			partitions.primary = (create-pt "100%" null (create-fs "ext4" "/data"));
		};
	};
in
{
	# disko.devices.mdadm.raid1 = storageconfig;
	disko.devices.disk =
	{
		# Boot disk 250GB
		main = 
		{
			device = "/dev/disk/by-id/ata-WDC_WD2500AAKX-08U6AA0_WD-WCC2EVL67736";
			type = "disk";

			content =
			{
				type = "gpt";
				partitions =
				{
					boot = (create-pt   "1M" "EF02" null); # grub mbr
					 ESP = (create-pt   "1G" "EF00" (create-fs "vfat" "/boot"));
					root = (create-pt "100%"  null  (create-fs "ext4" "/")); 
					swap = (create-pt   "8G"  null  ({ type = "swap"; }));
				};
			};
		};

		# -------------------- #

		# leafA = {
		# 	device = "/dev/disk/by-id/ata-ST3000DM001-1ER166_Z503KXW7";
		# 	type = "disk";

		# 	content = {
		# 		type = "gpt";
		# 		partitions.mdadm = data-raid-partition;
		# 	};
		# };


		# leafC = {
		# 	device = "/dev/disk/by-id/ata-ST3000DM001-1ER166_Z50344D2";
		# 	type = "disk";

		# 	content = {
		# 		type = "gpt";
		# 		partitions.mdadm = data-raid-partition;
		# 	};
		# };
	};
}
