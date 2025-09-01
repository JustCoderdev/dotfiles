{ lib, ... }:

{
	jcbin = {
		boomer.enable = true;
		eep.enable = true;
		gopro-control.enable = true;
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
					quiss = "f4:6d:04:99:dc:9a";
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
					(gen-builder "quiss.server.local" 4)
				];
			};
			nixcache.enable = true;
			routing =
			let
				get_conf = (hostname: host-mac: reserved-ip: domain: { inherit hostname host-mac reserved-ip domain; });
				hosts = [
					# (get_conf "switch"    "58:97:1e:94:b7:40" "10.0.0.2" "local")

					# -------------------- #

					(get_conf "alpha"     "1c:c1:de:be:c6:c4" "10.0.0.2" "server.local")
					# (get_conf "alpha"     "1c:c1:de:be:c6:c4" "10.0.0.3" "server.local")
					# (get_conf "alpha-ilo" "1c:c1:de:be:c6:c6" "10.0.0.4" "server.local")

					(get_conf "beta"      "30:8d:99:b2:88:df" "10.0.0.4" "server.local")
					# (get_conf "beta"      "30:8d:99:b2:88:df" "10.0.0.5" "server.local")
					# (get_conf "beta-ilo"  "30:8d:99:b2:88:dd" "10.0.0.6" "server.local")

					# (get_conf "quiss"     "f4:6d:04:99:cb:11" "10.0.0.7" "server.local")
					(get_conf "jarvis"    "3a:9c:e1:e5:ca:de" "10.0.0.8" "server.local")
				];
			in
			{
				enable = false;
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
					forwarded-ports = builtins.map (
						{ reserved-ip, ... }:
						let
							last-byte = lib.lists.last (lib.strings.splitString "." reserved-ip);
						in
						{
							proto = "tcp";
							sourcePort = lib.strings.toInt "50${last-byte}22";
							destination = "${reserved-ip}:22";
						}
					) hosts;
				};
			};
			samba = {
				enable = true;
				shares.user.enable = true;
			};
			webserver.enable = true;
		};
	};
}
