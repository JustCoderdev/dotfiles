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
			network.wakeOn.knownDevices = {
				quiss = "f4:6d:04:99:dc:9a";
				  msi = "d4:3b:04:51:45:28";
			};

			secrets =
			{
				cloudflare.origin-cert.installed = true;
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

		environments.development =
		{
			enable = true;
			tools.c.enable = true;
		};

		users.ryuji.media-manipulation-suite.images.enable = true;
	};

	modules.services.nixbuilder.client.builders =
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
		(gen-builder  "quiss.home.lan" 4)
	];
}
