{ ... }:

{
	jcbin.rebuild-system.enable = true;

	common.core.network.wakeOnLan = {
		enableFor = [ "eno1" ];
		knownDevices = {
			msi = "d4:3b:04:51:45:28";
		};
	};

	system = {
		dev.net.enable = true;

		services = {
			samba.enable = true;
			webserver.enable = false;
			nixbuilder = {
				server = {
					enable = true;
					maxJobs = 4;
					features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
				};
				client.builders =
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
					(gen-builder     "msi.host.local" 6)
					(gen-builder "alpha.server.local" 8)
					(gen-builder  "beta.server.local" 6)
				];
			};
		};
	};
}
