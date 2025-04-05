{ ... }:

{
	host.isVM = false;

	jcbin = {
		backlight.enable = false;
		rebuild-system.enable = true;
		mount-configs.enable = true;
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
			i3.enable = true;
			thunar.enable = true;
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
			nixcache.enable = false;
			nixbuilder = {
				server.enable = false;
				client.builders = [ ];
			};
		};
	};
}
