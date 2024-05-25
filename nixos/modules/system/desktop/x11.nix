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

				tapping = true;
				middleEmulation = false;
				tappingButtonMap = "lrm";
			};
		};
	};

}

