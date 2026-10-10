{
	jcbin.update-system.enable = true;

	common =
	{
		core =
		{
			secrets =
			{
				cloudflare.api-token.installed = true;
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
	};

	modules.services =
	{
		nixbuilder.client.builders =
		let
			gen-builder = (
				hostName: maxJobs: priority:
				{ inherit hostName maxJobs priority; }
			);
		in
		[
			(gen-builder  "msi.flat.lan" 6 2)
			(gen-builder "asus.flat.lan" 8 2)

			(gen-builder "quiss.garden.lan" 4 1)
			(gen-builder   "msi.garden.lan" 6 1)
		];

		wireguard.server =
		{
			enable = true;
			openFirewall = true;
			external-interface = "enp1s0";
		};

		xmpp =
		{
			enable = false;
			domain = "foxburrow.org";
		};
	};
}
