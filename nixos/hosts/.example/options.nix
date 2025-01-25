{ ... }:

{
	common = {
		core = {
			bluetooth.enable = false;
			nvidia.enable = false;

			audio = {
				pipewire.enable = false;
				pulseaudio.enable = false;
			};

			nix = {
				serve-store.enable = false;
			};
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = false;
				video-editing = false;
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
			xfce.enable = false;
			hyprland.enable = false;
		};

		dev = {
			enable = false;
			c.enable = false;
			arduino.enable = false;
			net.enable = false;
		};

		gaming.enable = false;
		services = {
			docker.enable = false;
			samba.enable = false;
			virtualbox.enable = false;
		};
	};
}
