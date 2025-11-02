{ ... }:

{
	jcbin = {
		backlight.enable = true;
		boomer.enable = true;
		rebuild-system.enable = true;
	};

	common = {
		core = {
			network.wakeOn.knownDevices = {
				quiss = "f4:6d:04:99:dc:9a";
				  msi = "d4:3b:04:51:45:28";
				 acer = "a4:17:31:10:9e:ed";
			};

			plymouth.enable = true;

			secrets = {
				cloudflare.origin-cert.installed = true;
				discord.hooks."foxburrow".rebuilds.installed = true;
			};

			ssh.cloudflared-proxy = {
				enable = true;
				hosts = [
					"jarvis-cf.foxburrow.org"
					"quiss-cf.foxburrow.org"
					"msi-cf.foxburrow.org"
				];
			};
		};

		users = {
			ryuji = {
				enable = true;

				docs-editing = true;
				image-editing = true;
			};
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
			samba = {
				enable = true;
				shares.user.enable = true;
			};
			webserver.enable = true;
			nixbuilder = {
				server = {
					enable = true;
					maxJobs = 8;
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
					(gen-builder "msi.foxburrow.org" 6)
					(gen-builder "msi.host.lan" 6)
				];
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
		};
	};
}
