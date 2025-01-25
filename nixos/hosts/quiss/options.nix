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
				serve-store.enable = true;
			};
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = false;
				video-editing = false;
			};
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
			enable = false;
			c.enable = false;
			arduino.enable = false;
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
