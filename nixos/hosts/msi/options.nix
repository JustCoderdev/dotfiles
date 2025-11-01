{ lib, ... }:

{
	jcbin = {
		boomer.enable = true;
		eep.enable = true;
		gopro-control.enable = true;
		rebuild-system.enable = true;
	};

	common = {
		core = {
			# network.wakeOn = {
				# wlan.enabledFor = [ "phy0" ];
				# knownDevices = {
				# 	quiss = "f4:6d:04:99:dc:9a";
				# 	 acer = "a4:17:31:10:9e:ed";
				# };
			# };

			plymouth.enable = true;

			secrets = {
				cloudflare = {
					origin-cert.installed = true;
					api-token.installed = true;
				};
				discord.hooks."foxburrow".rebuilds.installed = true;
			};

			ssh.cloudflared-proxy = {
				enable = true;
				hosts = [
					"jarvis.foxburrow.org"
					"quiss.foxburrow.org"
				];
			};
		};

		users.ryuji = {
			docs-editing = true;
			image-editing = true;
		};
	};

	system =
	{
		dev = {
			enable = true;
			android.enable = true;
			arduino.enable = true;
			c.enable = true;
			net.enable = true;
		};

		gaming.enable = true;

		services = {
			# docker.enable = true;
			nixbuilder = {
				server = {
					enable = true;
					maxJobs = 6;
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
					# (gen-builder "alpha.server.lan" 8)
					# (gen-builder  "beta.server.lan" 6)
					# (gen-builder "quiss.server.lan" 4)
				];
			};
			routing =
			let
				get_conf = (hostname: host-mac: reserved-ip: domain: { inherit hostname host-mac reserved-ip domain; });
				hosts = [
					# (get_conf "switch"    "58:97:1e:94:b7:40" "10.0.0.2" "local")

					# -------------------- #

					# (get_conf "alpha"     "1c:c1:de:be:c6:c4" "10.0.0.2" "server.lan")
					# (get_conf "alpha"     "1c:c1:de:be:c6:c4" "10.0.0.3" "server.lan")
					# (get_conf "alpha-ilo" "1c:c1:de:be:c6:c6" "10.0.0.4" "server.lan")

					# (get_conf "beta"      "30:8d:99:b2:88:df" "10.0.0.4" "server.lan")
					# (get_conf "beta"      "30:8d:99:b2:88:df" "10.0.0.5" "server.lan")
					# (get_conf "beta-ilo"  "30:8d:99:b2:88:dd" "10.0.0.6" "server.lan")

					# (get_conf "quiss"     "f4:6d:04:99:cb:11" "10.0.0.7" "server.lan")
					# (get_conf "jarvis"    "3a:9c:e1:e5:ca:de" "10.0.0.8" "server.lan")
					
					(get_conf "wise"    "8c:ec:4b:56:df:66" "10.0.0.9"  "server.lan")
					(get_conf "printer" "f4:a9:97:d5:1b:a1" "10.0.0.10" "server.lan")
				];
			in
			{
				enable = true;
				outnetwork.interface = "wlp3s0";
				subnetwork =
				{
					interface = "eno1";
					address = "10.0.0.0";
					mask = 24;
					self-ip = "10.0.0.1";
				};
				dhcp = {
					enable = true;
					range = "10.0.0.16,10.0.0.127"; 
					reserved-leases = hosts;
				};
				nat = {
					enable = true;
					forwarded-ports = [];
					# forwarded-ports = builtins.map (
					# 	{ reserved-ip, ... }:
					# 	let
					# 		last-byte = lib.lists.last (lib.strings.splitString "." reserved-ip);
					# 	in
					# 	{
					# 		proto = "tcp";
					# 		sourcePort = lib.strings.toInt "50${last-byte}22";
					# 		destination = "${reserved-ip}:22";
					# 	}
					# ) hosts;
				};
			};
			samba = {
				enable = true;
				shares.user.enable = true;
			};
			syncthing = 
			{
				enable = true;
				openFirewall = true;

				folders = [ "obsidian-db" ];
				devices =
				let
					add-device = (address: id: { inherit address id; });
				in
				{
					          msi = (add-device "10.255.250.1" "LGPPAMZ-TLOK2XH-JKCAXZQ-WLXTAAN-3SFRHCV-7AL7FBZ-B4EHV3E-MSRBHAI");
					        quiss = (add-device "10.255.250.2" "EWT7GNX-TSF5YRE-OTCN2ZH-A4OKVGI-QXCJQF4-OP7RBA2-PARSO2G-MFPKLAX");
					iphone-tp-2_0 = (add-device "10.255.250.3" "3G4X4WY-UUCQG3V-3I6BXWC-BJ5I6OW-YHUJQ4K-77TJU5N-DL62ASO-4DDWRAG");
					         asus = (add-device "10.255.250.4" "KTEN4FK-LK6SURY-N46K2Z6-5HTCGVR-24OPTRW-QFQBIVI-HFLYW2L-NE6W6Q7");
				};
			};
			wireguard.server =
			let
				add-peer = (ip: publicKey: { inherit ip publicKey ; });
			in
			{
				enable = true;
				openFirewall = true;

				external-interface = "wlp3s0";
				interfaces =
				{
					"wg-server" =
					{
						enable = true;
						tunnel-network = "10.255.250.0/24";
						self-ip = "10.255.250.1/24";

						peers =
						{
									quiss = (add-peer "10.255.250.2" "g01IZ3avpUFCXGsZwpTavv6AGPHHvRqL80SGfE+SYnI=");
							iphone-tp-2_0 = (add-peer "10.255.250.3" "WUEqbbv7RGfw9EhKjPDeZqwkuKwsODsdTtvMv7Gt+Vk=");
									 asus = (add-peer "10.255.250.4" "2KrNqM7coD0YRs9ggk+s2PmEwrH/6tuS5BwP+GS4T2w=");
						};
					};

					"wg-giugio" =
					{
						enable = true;
						port = 51821;

						tunnel-network = "10.255.249.0/24";
						self-ip = "10.255.249.1/24";

						peers =
						{
							telefono-giugio = (add-peer "10.255.249.2" "4rwmZnvgDpErgGh846y74GJ3EyWo+H/EqP8C4GULJGA=");
									pc-casa = (add-peer "10.255.249.3" "1LuDZtSSOh7YMlt3yq6pLZyOiLPisxbmn29RWvx2phY=");
								  pc-giugio = (add-peer "10.255.249.4" "ASVxaCdn8K/5scQOv+oWuJ9VWzQf/1mXxZi5tfwhblk=");
						};
					};
				};
			};
		};
	};
}
