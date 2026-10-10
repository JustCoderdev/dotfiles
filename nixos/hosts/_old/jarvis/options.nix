{
	jcbin.rebuild-system.enable = true;

	common.core.secrets =
	{
		discord.hooks."foxburrow".rebuilds.installed = true;
		wireless.installed = true;
	};

	modules.services =
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
		];
	};
}
