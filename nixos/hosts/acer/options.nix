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
			nixcache.instance-host = "msi.host.local";
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
