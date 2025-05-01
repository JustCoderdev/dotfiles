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

			network.wakeOn = {
				wlan.enabledFor = [ "phy0" ];
				knownDevices = {
					quiss = "f4:6d:04:99:cb:11";
					  msi = "d4:3b:04:51:45:28";
				};
			};

			audio.pipewire.enable = true;
			plymouth.enable = true;
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
			nixbuilder.client.builders = [
				{
					hostName = "msi.host.local";
					maxJobs = 6;
					features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
				}
			];
		};
	};
}
