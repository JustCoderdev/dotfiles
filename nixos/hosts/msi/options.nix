{ ... }:

{
	host.isVM = false;

	jcbin = {
		backlight.enable = false;
		rebuild-system.enable = true;
		mount-configs.enable = true;
	};

	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = true;

			audio = {
				pipewire.enable = false;
				pulseaudio.enable = true;
			};

			nix = {
				serve-store.enable = true;
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
		desktop = {
			hyprland.enable = false;
			i3.enable = true;
			thunar.enable = true;
			xfce.enable = false;
		};

		dev = {
			enable = true;
			android.enable = true;
			arduino.enable = true;
			c.enable = true;
			net.enable = false;
		};

		gaming.enable = true;
		services = {
			docker.enable = true;
			samba.enable = true;
			virtualbox.enable = false;
		};
	};
}
