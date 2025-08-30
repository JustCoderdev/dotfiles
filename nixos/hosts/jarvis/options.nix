{ ... }:

{
	jcbin.rebuild-system.enable = true;

	common.core = {
		bluetooth.enable = true;
		secrets = {
			cloudflare = {
				origin-cert.installed = true;
				tunnel-creds."jarvis-hass".installed = true;
			};
			wireless.installed = true;
		};
	};

	system.services = {
		home-assistant = {
			enable = true;
			openFirewall = false;
			proxy = {
				enable = true;
				host = "jarvis.server.local";
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
				(gen-builder      "192.168.7.209" 6) # Wired MSI
				(gen-builder     "msi.host.local" 6)
				(gen-builder "quiss.server.local" 4)
				# (gen-builder "alpha.server.local" 8)
				# (gen-builder  "beta.server.local" 6)
			];
		};
	};
}
