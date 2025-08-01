{ ... }:

{
	jcbin = {
		boomer.enable = true;
		eep.enable = true;
		rebuild-system.enable = true;
	};

	jcconfs.has_de = true;

	common = {
		core = {
			bluetooth.enable = true;

			hardware = {
				cpu = {
					manufacturer = "intel";
					architecture = "coffee-lake";
				};
				gpu = {
					manufacturer = "nvidia";
					architecture = "pascal";
				};
				displays =
				let
					add-display = identifier: resolution: position:
						{ inherit identifier resolution position; };
				in
				{
					a0-digiquest = add-display "HDMI-0" "1920x1080" "0x0";
					a1-digiquest = add-display "HDMI-1" "1920x1080" "0x0";
					b0-asus =      add-display "DP-0"   "1920x1080" "1920x0";
					b1-asus =      add-display "DP-1"   "1920x1080" "1920x0";
				};
			};

			network.wakeOn = {
				wlan.enabledFor = [ "phy0" ];
				knownDevices = {
					quiss = "f4:6d:04:99:cb:11";
					 acer = "a4:17:31:10:9e:ed";
				};
			};

			audio.pulseaudio.enable = true;
			plymouth.enable = true;

			secrets = {
				cloudflare.origin-cert.installed = true;
				nix-serve.priv-key.installed = true;
			};

			ssh.cloudflared-proxy = {
				enable = true;
				hosts = [ "ssh.foxburrow.org" ];
			};
		};

		users.ryuji = {
			docs-editing = true;
			image-editing = true;
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
			docker.enable = true;
			samba = {
				enable = true;
				shares.user.enable = true;
			};
			webserver.enable = true;
			nixcache.enable = true;
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
					(gen-builder "alpha.server.local" 8)
					(gen-builder  "beta.server.local" 6)
				];
			};
		};
	};
}
