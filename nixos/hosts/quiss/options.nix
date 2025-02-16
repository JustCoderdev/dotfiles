{ ... }:

{
	host.isVM = false;

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
			samba.enable = true;
			virtualbox.enable = false;
		};
	};
}
