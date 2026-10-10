{
	jcbin =
	{
		backlight.enable = true;
		boomer.enable = true;
		update-system.enable = true;
	};

	common =
	{
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
		(gen-builder    "msi.flat.lan" 6)
		(gen-builder  "msi.garden.lan" 6)
	];
}
