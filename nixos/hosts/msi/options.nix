{
	jcbin =
	{
		boomer.enable = true;
		eep.enable = true;
		gopro-control.enable = true;
		rebuild-system.enable = true;
	};

	common =
	{
		core =
		{
			secrets =
			{
				cloudflare = {
					origin-cert.installed = true;
					api-token.installed = true;
					tunnel-creds."msi-cf".installed = true;
				};
				discord.hooks."foxburrow".rebuilds.installed = true;
			};

			ssh.cloudflared-proxy =
			{
				enable = true;
				hosts = [
					"jarvis-cf.foxburrow.org"
					"quiss-cf.foxburrow.org"
					"msi-cf.foxburrow.org"
				];
			};
		};

		environments =
		{
			gaming.enable = true;
			development =
			{
				enable = true;
				tools = {
					android.enable = true;
					c.enable = true;
					network.enable = true;
				};
			};
		};

		users =
		{
			hass-agent.enable = true;
			ryuji.media-manipulation-suite =
			{
				documents.enable = true;
				images.enable = true;
				videos.enable = true;
			};
		};
	};

	system.services =
	{
		avahi.enable = true;

		nixbuilder.server =
		{
			enable = true;
			maxJobs = 6;
			features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
		};
		
		syncthing = 
		{
			enable = true;
			openFirewall = true;

			folders = [ "obsidian-db" ];
			devices =
			let
				add-device = (address: id: { inherit address id; });
			in
			{
						  msi = (add-device "10.255.250.1" "LGPPAMZ-TLOK2XH-JKCAXZQ-WLXTAAN-3SFRHCV-7AL7FBZ-B4EHV3E-MSRBHAI");
						quiss = (add-device "10.255.250.2" "OM3LICW-TEP5TOM-O2C4I5L-RE67TTX-CUD7TFZ-H4YHNKX-LOKOUMT-MFLJHAK");
				iphone-tp-2_0 = (add-device "10.255.250.3" "3G4X4WY-UUCQG3V-3I6BXWC-BJ5I6OW-YHUJQ4K-77TJU5N-DL62ASO-4DDWRAG");
						 asus = (add-device "10.255.250.4" "KTEN4FK-LK6SURY-N46K2Z6-5HTCGVR-24OPTRW-QFQBIVI-HFLYW2L-NE6W6Q7");
			};
		};

		wireguard.server =
		{
			enable = true;
			openFirewall = true;
			external-interface = "wlp3s0";
		};
	};
}
