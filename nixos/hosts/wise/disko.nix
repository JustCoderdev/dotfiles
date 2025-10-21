let
	create-fs = (
		format: mountpoint:
		{
			type = "filesystem";
			inherit format mountpoint;
		}
	};
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
				boot = {
					size = "1M";
					type = "EF02";
				};

				ESP = {
					size = "500M";
					type = "EF00";
					content = (create-fs "vfat" "/boot");
				};

				root = {
					size = "100%";
					content = (create-fs "ext4" "/");
				};

				swap = {	
					size = "1G";
					content.type = "swap";
				};
			};
		};
	};
}
