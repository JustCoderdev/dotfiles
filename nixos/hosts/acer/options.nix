{ ... }:

{
	host.isVM = false;

	jcbin = {
		backlight.enable = true;
		rebuild-system.enable = true;
		mount-configs.enable = true;
	};

	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = false;

			audio = {
				pipewire.enable = true;
				pulseaudio.enable = false;
			};
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
			enable = true;
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
			nixcache.instance-host = "192.168.7.142";  # msi 
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
