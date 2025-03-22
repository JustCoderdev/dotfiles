{ ... }:

{
	host.isVM = true;

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
			arduino.enable = false;
			c.enable = true;
			net.enable = false;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			samba.enable = false;
			virtualbox.enable = false;
			nixcache.enable = false;
		};
	};
}
