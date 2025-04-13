{ ... }:

{
	host.isVM = false;

	jcbin = {
		backlight.enable = false;
		boomer.enable = false;
		rebuild-system.enable = true;
		mount-configs.enable = true;
		umount-configs.enable = true;
	};

	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = false;

			audio = {
				pipewire.enable = true;
				pulseaudio.enable = false;
			};

			plymouth.enable = true;
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = false;
				game-developing = false;
			};

			neko.enable = true;
		};
	};

	system = {
		desktop = {
			hyprland.enable = false;
			i3.enable = true;
			thunar.enable = true;
			xfce.enable = false;
		};

		dev = {
			android.enable = false;
			arduino.enable = true;
			c.enable = true;
			net.enable = false;
		};

		gaming.enable = false;

		services = {
			docker.enable = false;
			samba.enable = true;
			virtualbox.enable = false;
			webserver.enable = true;
			nixcache.instance-host = "msi.host.local";
			nixbuilder = {
				server.enable = false;
				client.builders = [
					{
						hostName = "msi.host.local";
						maxJobs = 6;
						features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
						systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
					}
				];
			};
		};
	};
}
