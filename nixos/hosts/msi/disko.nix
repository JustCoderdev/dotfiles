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
in
{
	disko.devices.disk =
	{
		ssd =
		{
			device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ256HBJD-00BL2_S65FNE0R352852";
			type = "disk";

			content =
			{
				type = "gpt";
				partitions =
				{
					boot = (create-pt   "1M" "EF02" null); # grub mbr
					 ESP = (create-pt   "1G" "EF00" (create-fs "vfat" "/boot"));
					root = (create-pt "100%"  null  (create-fs "ext4" "/"));
				};
			};
		};

		# hdd =
		# {
		# 	device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y6VYJ99E";
		# 	type = "disk";

		# 	content =
		# 	{
		# 		type = "gpt";
		# 		partitions = { };
		# 	};
		# };
	};
}
