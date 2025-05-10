{ ... }:

{
	jcbin = {
		eep.enable = true;
		rebuild-system.enable = true;
	};

	common.core = {
		secrets = {
			discord-hook.installed = true;
			cloudflare = {
				origin-cert.installed = true;
				tunnel-creds."home".installed = true;
			};

			nginx.vhosts."quiss.server.local" = {
				cert = {
					installed = true;
					path = "/etc/nginx-certs/quiss_server_local-cert.crt";
				};
				key = {
					installed = true;
					path = "/etc/nginx-certs/quiss_server_local-cert.key";
				};
			};

			nix-serve.priv-key.installed = true;
		};
		network.wakeOn = {
			lan.enabledFor = [ "eno1" ];
			knownDevices = {
				 msi = "d4:3b:04:51:45:28";
				acer = "a4:17:31:10:9e:ed";
			};
		};
	};

	system.services = {
		samba.enable = true;
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
}
