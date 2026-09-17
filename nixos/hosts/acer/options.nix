{
	jcbin =
	{
		backlight.enable = true;
		boomer.enable = true;
		rebuild-system.enable = true;
	};

	common =
	{
		core =
		{
			network.wakeOn.knownDevices = {
				quiss = "f4:6d:04:99:dc:9a";
				  msi = "d4:3b:04:51:45:28";
			};

			ssh.cloudflared-proxy =
			{
				enable = false;
				hosts = [
					"jarvis-cf.foxburrow.org"
					"quiss-cf.foxburrow.org"
					"wise-cf.foxburrow.org"
					"msi-cf.foxburrow.org"
				];
			};
		};

		environments.development =
		{
			enable = true;
			tools.c.enable = true;
		};

		users.ryuji.media-manipulation-suite.images.enable = true;
	};

	modules.services =
	{
		syncthing =
		{
			enable = true;
			openFirewall = true;

			dataDir = "/home/ryuji/Documents/synced";
			folders = [ "obsidian-db" ];
			devices =
			let
				add-device = (address: id: { inherit id; address = if address == null then null else "tcp://${address}"; });
			in
			{
						quiss = (add-device "quiss.garden.lan" "OM3LICW-TEP5TOM-O2C4I5L-RE67TTX-CUD7TFZ-H4YHNKX-LOKOUMT-MFLJHAK");
				iphone-tp-3_0 = (add-device               null "MBQSGMY-3EBNA67-XQLOXDU-UT3QL7Y-4MQO633-YOOEA5U-LT5RFVC-JYGAXQH");
						 asus = (add-device  "asus.garden.lan" "KTEN4FK-LK6SURY-N46K2Z6-5HTCGVR-24OPTRW-QFQBIVI-HFLYW2L-NE6W6Q7");
						  msi = (add-device   "msi.garden.lan" "LGPPAMZ-TLOK2XH-JKCAXZQ-WLXTAAN-3SFRHCV-7AL7FBZ-B4EHV3E-MSRBHAI");
				  ipad-tp-2_0 = (add-device               null "WNA7TTR-2GZ7QRH-4HXPAJT-QAI7VVM-MCX3ZFC-WPXG3UB-CGMPF4C-YKTCSA7");
			};
		};

		nixbuilder.client.builders =
		let
			gen-builder = (
				hostName: maxJobs:
				{
					inherit hostName maxJobs;
					features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
				}
			);
		in
		[
			(gen-builder    "msi.flat.lan" 6)
			(gen-builder  "msi.garden.lan" 6)
		];
	};
}
