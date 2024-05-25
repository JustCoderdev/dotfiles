{ settings, ... }:
let
	username = settings.username;
in {
	imports = [ ./x11.nix ];

	services.xserver.displayManager = {
		ly = {
			enable = false;
			defaultUser = username;
			#defaultSessionIndex = 2;

			#Extra config to be added to the config.ini file
			extraConfig = ''
# Animation enabled/disabled
animate = true

# The active animation
# 0 -> PSX DOOM fire (default)
# 1 -> CMatrix
#animation = 0

# format string for clock in top right corner (see strftime specification)
#clock = %c

# enable/disable big clock
#bigclock = true

# The character used to mask the password
asterisk = *

# Erase password input on failure
blank_password = true

#The `fg` and `bg` color settings take a digit 0-8 corresponding to:
#define TB_DEFAULT 0x00
#define TB_BLACK   0x01
#define TB_RED     0x02
#define TB_GREEN   0x03
#define TB_YELLOW  0x04
#define TB_BLUE    0x05
#define TB_MAGENTA 0x06
#define TB_CYAN    0x07
#define TB_WHITE   0x08
#
# Setting both to zero makes `bg` black and `fg` white. To set the actual color palette you are encouraged to use another tool
# such as [mkinitcpio-colors](https://github.com/evanpurkhiser/mkinitcpio-colors). Note that the color palette defined with
# `mkinitcpio-colors` takes 16 colors (0-15), only values 0-8 are valid for `ly` config and these values do not correspond
# exactly. For instance, in defining palettes with `mkinitcpio-colors` the order is black, dark red, dark green, brown, dark
# blue, dark purple, dark cyan, light gray, dark gray, bright red, bright green, yellow, bright blue, bright purple, bright
# cyan, and white, indexed in that order 0 through 15. For example, the color defined for white (indexed at 15 in the mkinitcpio
# config) will be used by `ly` for `fg = 8`.

# Background color id
#bg = 0

# Foreground color id
#fg = 9

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
