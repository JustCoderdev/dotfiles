let
	create-fs = (
		format: mountpoint:
		{
			type = "filesystem";
			inherit format mountpoint;
		}
	);
in
{
	disko.devices.disk.main =
	{
		device = "/dev/nvme0n1";
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
					size = "1G";
					type = "EF00";
					content = (create-fs "vfat" "/boot");
				};

				root = {
					size = "100%";
					content = (create-fs "ext4" "/");
				};
			};
		};
	};
}

