{ config, lib, ... }:

with lib;
let cfg = config.system.desktop.xfce; in

{
	config = mkIf cfg.enable {
		services.xserver = {
			enable = true;

			# Enable touchpad support.
			libinput = {
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
	};
}

