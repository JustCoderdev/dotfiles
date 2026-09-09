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
	disko.devices.disk.hdd =
	{
		device = "/dev/disk/by-id/ata-Hitachi_HTS545050A7E380_TEA51A3RJUY16R";
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
}
