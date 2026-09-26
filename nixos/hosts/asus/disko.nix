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
	disko.devices.disk.nvme-29fc =
	{
		device = "/dev/disk/by-id/nvme-WDC_PC_SN520_SDAPNUW-128G-1032_1902D4803809";
		type = "disk";

		content =
		{
			type = "gpt";
			partitions =
			{
				boot = (create-pt   "1M" "EF02" null); # grub mbr
				 esp = (create-pt   "1G" "EF00" (create-fs "vfat" "/boot"));
				swap = (create-pt   "8G"  null  ({ type = "swap"; }));
				root = (create-pt "100%"  null  (create-fs "ext4" "/"));
			};
		};
	};
}
