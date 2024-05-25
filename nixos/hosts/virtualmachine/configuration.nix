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
				video-editing = true;
				developer = true;
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
		desktop.wayland.enable = true;

		dev = {
			c.enable = true;
			arduino.enable = true;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			virtualbox.enable = false;
		};
	};
}
