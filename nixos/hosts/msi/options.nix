{
	jcbin =
	{
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
		};

		environments =
		{
			gaming =
			{
				enable = true;
				vr.enable = true;
			};

			development =
			{
				enable = true;
				tools = {
					android.enable = true;
					network.enable = true;
					game-development.enable = true;
					c.enable = true;
					java.enable = true;
				};
			};
		};

		users =
		{
			school.enable = true;

			ryuji.media-manipulation-suite =
			{
				documents.enable = true;
				images.enable = true;
				videos.enable = true;
			};
		};
	};

	modules.services =
	{
		samba.enable = true;
		nixbuilder.server =
		{
			enable = true;
			maxJobs = 6;
		};
	};
}
