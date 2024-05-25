{ settings, ... }:
let
	username = settings.username;
in {
	imports = [ ./x11.nix ];

	services.xserver.displayManager = {
		ly = {
			enable = false;
			defaultUser = username;

			#Extra config to be added to the config.ini file
			extraConfig = ''
# Animation enabled/disabled
animate = true

# The active animation
# 0 -> PSX DOOM fire (default)
# 1 -> CMatrix
animation = 1

# format string for clock in top right corner (see strftime specification)
clock = %c

# enable/disable big clock
bigclock = true

# The character used to mask the password
asterisk = *

# Erase password input on failure
blank_password = true

# Blank main box background
# Setting to false will make it transparent
blank_box = true

# Remove main box borders
#hide_borders = false

# Main box margins
#margin_box_h = 2
#margin_box_v = 1

# Input boxes length
input_len = 20  #34

# Max input sizes
#max_desktop_len = 100
#max_login_len = 255
#max_password_len = 255

# Input box active by default on startup
#default_input = 2
				'';
		};
	};
}
