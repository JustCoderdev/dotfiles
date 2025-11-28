{
	jcbin.rebuild-system.enable = true;

	common.core.secrets =
	{
		cloudflare = {
			origin-cert.installed = true;
			tunnel-creds."jarvis-hass".installed = true;
		};
		discord.hooks."foxburrow".rebuilds.installed = true;
		wireless.installed = true;
	};

	system.services =
	{
		home-assistant.enable = true;

		nixbuilder.client.builders =
		let
			gen-builder = (
				hostName: maxJobs: priority:
				{ inherit hostName maxJobs priority; }
			);
		in
		[
			(gen-builder "quiss.home.lan" 4 2)
			(gen-builder  "asus.home.lan" 8 2)

			(gen-builder "quiss.garden.lan" 4 1)
			(gen-builder   "msi.garden.lan" 6 1)
		];
	};
}
