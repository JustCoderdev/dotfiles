let
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
		// lib.attrs.optional (type != null) { inherit type; }
		// lib.attrs.optional (content != null) { inherit content; }
	);
in
{
	disko.devices.disk.flash =
	{
		device = "/dev/mmcblk1";
		type = "disk";

		content =
		{
			type = "gpt";

			partitions =
			{
				boot = (create-pt   "1M" "EF02" null); # grub mbr
				 ESP = (create-pt "500M" "EF00" (create-fs "vfat" "/boot"));
				root = (create-pt "100%"  null  (create-fs "ext4" "/")); 
				swap = (create-pt   "1G"  null  ({ type = "swap"; }));
			};
		};
	};
}
