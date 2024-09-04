{ ... }:

{
	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = true;

			audio = {
				pipewire.enable = false;
				pulseaudio.enable = true;
			};
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = true;
			};

			school.enable = false;
		};
	};

	system = {
		bin = {
			backlight.enable = false;
			rebuild-system.enable = true;
		};

		desktop = {
			xfce.enable = true;
			hyprland.enable = false;
		};

		dev = {
			enable = true;
			c.enable = true;
			arduino.enable = true;
			net.enable = true;
		};

		gaming.enable = true;
		services = {
			docker.enable = true;
			samba.enable = true;
			virtualbox.enable = false;
		};
	};
}
