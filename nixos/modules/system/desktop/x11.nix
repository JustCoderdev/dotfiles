{ ... }:

{
	# Enable the X11 windowing system.
	services.xserver = {
		enable = true;

		# Configure keymap in X11
		layout = "it";
		xkbVariant = "";

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

}

