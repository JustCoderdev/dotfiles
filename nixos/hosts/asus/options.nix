{ ... }:

{
	jcbin = {
		backlight.enable = true;
		boomer.enable = true;
		rebuild-system.enable = true;
	};

	jcconfs.has_de = true;

	common = {
		core = {
			bluetooth.enable = true;

			hardware = {
				cpu = {
					manufacturer = "intel";
					architecture = "ice-lake";
					has-iGPU = true;
				};
				gpu = {
					manufacturer = "nvidia";
					architecture = "maxwell";
					offload = {
						enable = true;
						intelBusId = "PCI:0:2:0";
						nvidiaBusId = "PCI:2:0:0";
					};
				};
				displays =
				let
					add-display = identifier: resolution: position:
						{ inherit identifier resolution position; };
				in
				{
					a-ig-monitor = add-display "eDP-1"  "1920x1080" "0x0";
					b-ex-monitor = add-display "HDMI-1" "1920x1080" "1920x0";
				};
			};

			network.wakeOn.knownDevices = {
				quiss = "f4:6d:04:99:dc:9a";
				  msi = "d4:3b:04:51:45:28";
				 acer = "a4:17:31:10:9e:ed";
			};

			audio.pulseaudio.enable = true;
			plymouth.enable = true;

			secrets = {
				cloudflare.origin-cert.installed = true;
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

		users = {
			ryuji = {
				enable = true;

				docs-editing = true;
				image-editing = true;
			};
		};
	};

	system = {
		desktop = {
			i3.enable = true;
			thunar.enable = true;
		};

		dev = {
			android.enable = true;
			arduino.enable = true;
			c.enable = true;
			net.enable = true;
		};

		gaming.enable = true;

		services = {
			samba.enable = true;
			webserver.enable = true;
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
					        quiss = (add-device "10.255.250.2" "GBMMYZW-5BMWHRK-KWT57VY-HFT2OQZ-VEONSJ2-K7NLEXG-P4HU7CB-3DVFFAQ");
					iphone-tp-2_0 = (add-device "10.255.250.3" "3G4X4WY-UUCQG3V-3I6BXWC-BJ5I6OW-YHUJQ4K-77TJU5N-DL62ASO-4DDWRAG");
					         asus = (add-device "10.255.250.4" "");
				};
			};
			wireguard = {
				openFirewall = true;
				client =
				{
					enable = true;
					servers.wg-msi = {
						endpoint = "msi.foxburrow.org:51820";
						publicKey = "FHDRB/hzK85kTPMDJH6IZTRakcy3tl8Qy9vLG7/JujQ=";

						self-ip = "10.255.250.4/24";
						allowed-ips = [
							"10.255.250.1/32" # msi
							"10.255.250.2/32" # quiss
							"10.255.250.3/32" # iphone-tp-2_0
						];
					};
				};
			};
		};
	};
}
