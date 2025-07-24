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
				};
				gpu = {
					manufacturer = "nvidia";
					architecture = "maxwell";
				};
				displays =
				let
					add-display = identifier: resolution: position:
						{ inherit identifier resolution position; };
				in
				{
					ig-monitor =      add-display "eDP-1"   "1920x1080" "0x0";
				};
			};

			audio.pulseaudio.enable = true;
			plymouth.enable = true;

			secrets = {
				cloudflare.origin-cert.installed = false;
				nix-serve.priv-key.installed = false;
			};

			ssh.cloudflared-proxy = {
				enable = false;
				hosts = [ "ssh.foxburrow.org" ];
			};
		};

		users = {
			ryuji = {
				enable = true;

				docs-editing = true;
				image-editing = true;
			};

			neko.enable = true;
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

		services = {
			samba.enable = true;
			webserver.enable = true;
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
					(gen-builder "msi.host.local" 6)
				];
			};
		};
	};
}
