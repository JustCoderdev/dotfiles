{ ... }:

{
	jcbin = {
		backlight.enable = true;
		boomer.enable = true;
		eep.enable = true;
		rebuild-system.enable = true;
	};

	jcconfs.has_de = true;

	common = {
		core = {
			bluetooth.enable = true;

			hardware = {
				cpu.manufacturer = "intel";

				displays =
				let
					add-display = identifier: resolution: position:
						{ inherit identifier resolution position; };
				in
				{
					laptop-monitor = add-display "VGA-1" "1920x1080" "0x0";
				};
			};
			
			network.wakeOn.knownDevices = {
				quiss = "f4:6d:04:99:dc:9a";
				  msi = "d4:3b:04:51:45:28";
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

		users.ryuji.image-editing = true;
	};

	system = {
		desktop = {
			i3.enable = true;
			thunar.enable = true;
		};

		dev = {
			arduino.enable = true;
			c.enable = true;
		};

		services = {
			samba = {
				enable = true;
				shares.user.enable = true;
			};
			webserver.enable = true;
			nixbuilder.client.builders =
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
				(gen-builder "quiss.server.lan" 4)
			];
		};
	};
}
