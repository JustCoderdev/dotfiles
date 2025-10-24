{ ... }:

{
	jcbin.rebuild-system.enable = true;

	common.core = {
		secrets = {
			cloudflare = {
				origin-cert.installed = true;
				tunnel-creds."jarvis-hass".installed = true;
			};
			discord.hooks."foxburrow".rebuilds.installed = true;
			wireless.installed = true;
		};
	};

	system.services = {
		home-assistant = {
			enable = true;
			openFirewall = false;
			proxy = {
				enable = true;
				host = "jarvis.server.lan";
			};
		};
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
				# (gen-builder      "msi.host.lan" 6)

				(gen-builder "msi.foxburrow.org" 6)
				(gen-builder  "quiss.server.lan" 4)
				(gen-builder      "192.168.7.34" 8)

				# (gen-builder "alpha.server.lan" 8)
				# (gen-builder  "beta.server.lan" 6)
			];
		};
	};
}
