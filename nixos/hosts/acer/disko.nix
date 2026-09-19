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
	disko.devices.disk.ssd =
	{
		device = "/dev/disk/by-id/ata-KINGSTON_SKC600256G_50026B7784ED9F1D";
		type = "disk";

		content =
		{
			type = "gpt";
			partitions =
			{
				boot = (create-pt   "1M" "EF02" null); # grub mbr
				 ESP = (create-pt   "1G" "EF00" (create-fs "vfat" "/boot"));
				swap = (create-pt   "8G"  null  ({ type = "swap"; }));
				root = (create-pt "100%"  null  (create-fs "ext4" "/"));
			};
		};
	};
}
