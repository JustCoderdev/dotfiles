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
		};
	};
}
