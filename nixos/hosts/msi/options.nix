{
	jcbin =
	{
		boomer.enable = true;
		rebuild-system.enable = true;
	};

	common =
	{
		core =
		{
			printing.enable = true;

			secrets =
			{
				cloudflare = {
					origin-cert.installed = true;
					api-token.installed = true;
					tunnel-creds."msi-cf".installed = true;
				};
				discord.hooks."foxburrow".rebuilds.installed = true;

				nginx.vhosts."_" = {
					cert = {
						installed = true;
						path = "/etc/nginx-certs/_-cert.crt";
					};
					key = {
						installed = true;
						path = "/etc/nginx-certs/_-cert.key";
					};
				};
			};

			ssh.cloudflared-proxy =
			{
				enable = true;
				hosts = [
					"jarvis-cf.foxburrow.org"
					"quiss-cf.foxburrow.org"
					"wise-cf.foxburrow.org"
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

			school.enable = true;

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
		};

		syncthing =
		{
			enable = true;
			openFirewall = true;

			dataDir = "/home/WDC_WD10/synced";
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
	};
}
