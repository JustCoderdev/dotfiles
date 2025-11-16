{
	jcbin.rebuild-system.enable = true;

	common =
	{
		core =
		{
			network.wakeOn =
			{
				# lan.enabledFor = [ "enp1s0" ];
				knownDevices.msi = "d4:3b:04:51:45:28";
			};

			secrets =
			{
				cloudflare = {
					origin-cert.installed = true;
					api-token.installed = true;
					tunnel-creds."wise-cf".installed = true;
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
					"msi-cf.foxburrow.org"
				];
			};
		};
	};

	system.services =
	{
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
			(gen-builder  "msi.flat.lan" 6)
			(gen-builder "asus.flat.lan" 8)

			(gen-builder "quiss.garden.lan" 4)
			(gen-builder   "msi.garden.lan" 6)
		];

		wireguard.server =
		{
			enable = true;
			openFirewall = true;
			external-interface = "enp1s0";
		};
	};
}
