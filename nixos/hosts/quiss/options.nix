{ ... }:

{
	jcbin.rebuild-system.enable = true;

	common.core = {
		hardware = {
			cpu = {
				manufacturer = "intel";
				architecture = "ivy-bridge";
			};
			# Radeon HD 6750
			# gpu = {
			# 	manufacturer = "amd";
			# 	architecture = "gcn1";
			# };
			# AMD FirePro W4300
			gpu = {
				manufacturer = "amd";
				architecture = "gcn2";
			};
		};
		secrets = {
			nginx.basic_auth."dashboard".file.installed = true;
			discord-hook.installed = true;
			cloudflare = {
				origin-cert.installed = true;
				tunnel-creds."home".installed = true;
			};

			nginx.vhosts."quiss.server.lan" = {
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
			lan.enabledFor = [ "eno1" "enp8s2" ];
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
				(gen-builder     "msi.host.lan" 6)
				(gen-builder "alpha.server.lan" 8)
				(gen-builder  "beta.server.lan" 6)
			];
		};
		# routing =
		# let
		# 	get_conf = (hostname: host-mac: reserved-ip: domain: { inherit hostname host-mac reserved-ip domain; });
		# 	hosts = [
		# 		(get_conf "display" "00:03:50:01:06:48" "192.168.1.50" "local")
		# 	];
		# in
		# {
		# 	enable = true;
		# 	outnetwork.interface = "eno1";
		# 	subnetwork =
		# 	{
		# 		interface = "enp8s2";
		# 		address = "192.168.1.0";
		# 		mask = 24;
		# 		self-ip = "192.168.1.1";
		# 	};
		# 	dhcp = {
		# 		enable = false;
		# 		range = "10.0.0.16,10.0.0.127"; 
		# 		reserved-leases = [ ];
		# 	};
		# 	nat = {
		# 		enable = true;
		# 		forwarded-ports = [
		# 			{
		# 				proto = "tcp";
		# 				sourcePort = 20000;
		# 				destination = "192.168.1.50:20000";
		# 			}
		# 		];
		# 	};
		# };
	};
}
