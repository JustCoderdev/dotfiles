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

		desktop.xfce.enable = false;
		desktop.hyprland.enable = true;

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
