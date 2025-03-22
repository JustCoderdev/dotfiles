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
			enable = false;
			android.enable = false;
			arduino.enable = false;
			c.enable = false;
			net.enable = true;
		};

		gaming.enable = false;

		services = {
			docker.enable = false;
			samba.enable = true;
			virtualbox.enable = false;
			nixcache.enable = true;
		};
	};
}
