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
			secrets.discord.hooks."foxburrow".rebuilds.installed = true;
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
		samba.enable = true;
		uxplay = {
			enable = true;
			openFirewall = true;
		};
	};
}
