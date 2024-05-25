{ ... }:

{
	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = true;
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = false;
				developer = false;
			};

			school.enable = false;
		};
	};

	system = {
		bin = {
			backlight.enable = true;
			rebuild-system.enable = true;
		};

		desktop.xfce.enable = false;
		desktop.hyprland.enable = true;

		dev = {
			c.enable = true;
			arduino.enable = true;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			samba.enable = false;
			virtualbox.enable = false;
		};
	};
}
