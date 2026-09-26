{
	jcbin =
	{
		backlight.enable = true;
		boomer.enable = true;
		update-system.enable = true;
	};

	common =
	{
		core =
		{
			printing.enable = true;

			secrets =
			{
				# cloudflare.origin-cert.installed = true;
				# discord.hooks."foxburrow".rebuilds.installed = true;
			};

			# ssh.cloudflared-proxy =
			# {
			# 	enable = true;
			# 	hosts = [
			# 		"jarvis-cf.foxburrow.org"
			# 		"quiss-cf.foxburrow.org"
			# 		"wise-cf.foxburrow.org"
			# 		"msi-cf.foxburrow.org"
			# 	];
			# };
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

		uxplay = {
			enable = true;
			openFirewall = true;
		};
	};
}
