{
	disko.devices.disk.flash=
	{
		device = "/dev/mmcblk1";
		type = "disk";
		content =
		{
			type = "gpt";
			partitions =
			{
				boot = {
					name = "boot";
					size = "1M";
					type = "EF02";
				};

				esp =
				{
					name = "ESP";
					size = "500M";
					type = "EF00";
					content =
					{
						type = "filesystem";
						format = "vfat";
						mountpoint = "/boot";
					};
				};

				root =
				{
					size = "100%";
					content =
					{
						type = "filesystem";
						format = "ext4";
						mountpoint = "/";
					};
				};

				swap = 
				{	
					size = "1G";
					content.type = "swap";
				};
			};
		};
	};
}
