{ ... }:

{
	imports = [ ./fonts.nix ];

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
				clickMethod = "clickfinger";
				scrollMethod = "twofinger";

				# dmesg | grep i8042
				dev = "/devices/platform/i8042/serio1/input/input5";

				tapping = true;
				middleEmulation = false;
				tappingButtonMap = "lrm";
			};
		};
	};

}

