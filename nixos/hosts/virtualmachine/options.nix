{ ... }:

{
	host.isVM = true;

	common = {
		core = {
			bluetooth.enable = false;
			nvidia.enable = false;

			audio = {
				pipewire.enable = true;
				pulseaudio.enable = false;
			};

			nix = {
				serve-store.enable = false;
			};
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = false;
				game-developing = false;
			};
		};
	};

	system = {
		bin = {
			backlight.enable = true;
			rebuild-system.enable = true;
		};

		desktop = {
			hyprland.enable = false;
			i3.enable = true;
			thunar.enable = true;
			xfce.enable = false;
		};

		dev = {
			enable = true;
			android.enable = false;
			arduino.enable = false;
			c.enable = true;
			net.enable = false;
		};

		gaming.enable = false;
		services = {
			docker.enable = true;
			samba.enable = false;
			virtualbox.enable = false;
		};
	};
}
