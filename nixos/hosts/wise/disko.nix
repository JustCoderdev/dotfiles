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
	disko.devices.disk.flash =
	{
		device = "/dev/disk/by-id/mmc-DF4016_0x9a10f542";
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
