let
	optionalattrs = (
		expr: set:
		if expr then set else { }
	);

	create-fs = (
		format: mountpoint: mountOptions:
		{
			type = "filesystem";
			inherit format mountpoint mountOptions;
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
		flash =
		{
			device = "/dev/disk/by-id/mmc-DF4016_0x9a10f542";
			type = "disk";

			content =
			{
				type = "gpt";
				partitions =
				{
					boot     = (create-pt   "1M" "EF02" null); # grub mbr
					 ESP     = (create-pt   "1G" "EF00" (create-fs "vfat" "/boot" [ ]));
					recovery = (create-pt "100%"  null  null);
				};
			};
		};

		usb-drive =
		{
			device = "usb-USB_SanDisk_3.2Gen1_03021919050425053140-0:0";
			type = "disk";

			content =
			{
				type = "gpt";
				partitions =
				{
					root = (create-pt "100%" null (create-fs "f2fs" "/" [ "noatime" ]));
				};
			};
		};
	};
}
