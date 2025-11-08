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
				hostName: maxJobs:
				{
					inherit hostName maxJobs;
					features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
				}
			);
		in
		[
			(gen-builder     "foxburrow.org" 6)
			(gen-builder  "quiss.server.lan" 4)
		];
	};
}
