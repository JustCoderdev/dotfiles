{ ... }:

{
	common = {
		core = {
			bluetooth.enable = false;
			nvidia.enable = false;
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = false;
			};

			school.enable = false;
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
			net.enable = true;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			samba.enable = false;
			virtualbox.enable = false;
		};
	};

	# Temporary fix
	networking.networkmanager.appendNameservers = [
		"192.168.1.59"
		"192.168.2.1"
	];
}
