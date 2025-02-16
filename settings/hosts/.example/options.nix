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
			mount-configs.enable = true;
		};

		desktop = {
			hyprland.enable = false;
			i3.enable = true;
			thunar.enable = true;
			xfce.enable = false;
		};

		dev = {
			enable = false;
			android.enable = false;
			arduino.enable = false;
			c.enable = false;
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
