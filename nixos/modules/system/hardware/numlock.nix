{ pkgs, ... }:

{
	boot.initrd.preLVMCommands = ''
		${pkgs.kbd}/bin/setleds +num
	'';

	services.xserver.displayManager.setupCommands = ''
		${pkgs.numlockx}/bin/numlockx on
	'';

	# $ gsettings reset org.gnome.desktop.input-sources xkb-options
	# $ gsettings reset org.gnome.desktop.input-sources sources
	services.xserver.xkbOptions = "numpad:mac";

	# ctrl			Ctrl position
	# "ctrl:swapcaps"	Swap Ctrl and Caps Lock

	# grp_led 		Use keyboard LED to show alternative layout
	# "grp_led:num" 	Num Lock
	# "grp_led:caps" 	Caps Lock
	# "grp_led:scroll" 	Scroll Lock

	# mod_led	  	Use keyboard LED to indicate modifiers
	# "mod_led:compose"	Compose

	# caps			Caps Lock behaviour
	# "caps:ctrl_modifier"	Make Caps Lock an additional Ctrl
	# "caps:none"		Disable Caps Lock

	# compat		Compatibility options
	# "numpad:pc"		Default numeric keypad keys
	# "numpad:mac"		Numeric keypad always enters digits (as in macOS)
}
