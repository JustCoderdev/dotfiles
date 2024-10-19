{ ... }:

{
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

			school.enable = true;
		};
	};

	system = {
		bin = {
			backlight.enable = true;
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
			net.enable = false;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			samba.enable = true;
			virtualbox.enable = false;
		};
	};
}
