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
			bluetooth.enable = false;
			nvidia.enable = false;

			audio = {
				pipewire.enable = false;
				pulseaudio.enable = false;
			};

			plymouth.enable = false;
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = false;
				video-editing = false;
				game-developing = false;
			};

			neko.enable = true;
		};
	};

	system = {
		desktop = {
			hyprland.enable = false;
			i3.enable = false;
			thunar.enable = false;
			xfce.enable = false;
		};

		dev = {
			android.enable = false;
			arduino.enable = false;
			c.enable = false;
			net.enable = false;
		};

		gaming.enable = false;

		services = {
			docker.enable = false;
			samba.enable = false;
			virtualbox.enable = false;
			webserver.enable = false;
			nixcache.instance-host = "msi.host.local";
			nixbuilder = {
				server = {
					enable = true;
					maxJobs = 6;
					features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
				};
				client.builders = [ ];
			};
		};
	};
}
