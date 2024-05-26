{ config, lib, settings, ... }:

let cfg = config.system.desktop.xfce; in

{
	config = lib.mkIf cfg.enable {
		services.xserver.enable = true;
		services.libinput = {
			enable = true;

			mouse = {
				middleEmulation = false;
			};

			touchpad = {
				accelProfile = "flat";       # flat, adaptive
				clickMethod = "buttonareas"; # buttonareas, clickfinger

				# dmesg | grep i8042
				# dev = "/devices/platform/i8042/serio1/input/input5";
				middleEmulation = false;
				scrollMethod = "twofinger";

				tapping = true;
				tappingDragLock = false;
				tappingButtonMap = "lrm";
			};
		};
	};
}

