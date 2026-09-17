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
			network.wakeOn =
			{
				lan.enabledFor = [ "eno1" "enp8s2" ];
				wlan.enabledFor = [ "phy0" ];
				knownDevices.wise = "8c:ec:4b:56:df:66";
			};

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

	modules.services =
	{
		avahi.enable = true;

		nixbuilder.server =
		{
			enable = true;
			maxJobs = 6;
		};

		samba = {
			enable = true;
			# shares.user.enable = true;
		};
	};
}
