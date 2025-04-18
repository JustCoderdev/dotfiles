{ lib, ... }:

{
	jcbin.rebuild-system.enable = true;

	jcconfs.services.home-assistant = true;

	common.core.bluetooth.enable = true;

	system.services = {
		kvm = {
			enable = true;
			allowedBridges = [ "br0" ];
		};
		nixcache.instance-host = "msi.host.local";
		nixbuilder = {
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
				# (gen-builder "alpha.server.local" 8)
				# (gen-builder  "beta.server.local" 6)
			];
		};
	};
}
