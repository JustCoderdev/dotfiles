{ type, cpu, gpu, ... }:

{
	hardware =
	{
		system = "x86_64-linux";
		type = type.desktop;

		audio.capable = false;
		bluetooth.capable = false;

		cpu.intel  = "ivy-bridge";
		gpu.radeon = "gcn-1"; # Radeon HD 6750

		graphics =
		{
			capable = true;
			desktop-environment.enable = false;

			displays = { };
		};
	};

	# -------------------- #

	software =
	{
		syncthing =
		{
			enable = true;
			data-dir = "/mnt/md0/data/documents/synced";
			identification = "OM3LICW-TEP5TOM-O2C4I5L-RE67TTX-CUD7TFZ-H4YHNKX-LOKOUMT-MFLJHAK";
		};

		wireguard."wg-server" =
		{
			enable = true;
			publicKey = "g01IZ3avpUFCXGsZwpTavv6AGPHHvRqL80SGfE+SYnI=";
			self-address = "10.255.250.2";
		};
	};
}

