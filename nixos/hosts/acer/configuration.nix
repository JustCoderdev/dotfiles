{ ... }:

{
	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = false;
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = false;
				developer = false;
			};

			school.enable = true;
		};
	};

	system = {
		bin = {
			backlight.enable = true;
			rebuild-system.enable = true;
		};

		desktop.xfce.enable = true;
		desktop.hyprland.enable = false;

		dev = {
			c.enable = true;
			arduino.enable = true;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			samba.enable = true;
			virtualbox.enable = false;
		};
	};
}

