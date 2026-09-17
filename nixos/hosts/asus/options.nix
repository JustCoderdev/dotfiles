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
			printing.enable = true;

			network.wakeOn.knownDevices =
			{
				quiss = "f4:6d:04:99:dc:9a";
				  msi = "d4:3b:04:51:45:28";
			};

			secrets =
			{
				cloudflare.origin-cert.installed = true;
				discord.hooks."foxburrow".rebuilds.installed = true;
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
					java.enable = true;
					network.enable = true;
				};
			};
		};

		users.ryuji.media-manipulation-suite =
		{
			documents.enable = true;
			images.enable = true;
		};
	};

	modules.services =
	{
		avahi.enable = true;

		nixbuilder.client.builders =
		let
			gen-builder = (
				hostName: maxJobs: priority:
				{ inherit hostName maxJobs priority; }
			);
		in
		[
			# (gen-builder "quiss.home.local" 4 2)
			#
			# (gen-builder   "msi.home.local" 6 2)
			# (gen-builder   "msi.flat.local" 6 2)
			#
			# (gen-builder "quiss.garden.lan" 4 1)
			# (gen-builder   "msi.garden.lan" 6 1)
		];

		uxplay = {
			enable = true;
			openFirewall = true;
		};
	};
}
