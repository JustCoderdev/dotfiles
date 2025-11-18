{ lib, pkgs, ... }:

{
	services.xserver.displayManager.setupCommands = ''
${pkgs.numlockx}/bin/numlockx on
'';

	# `man xkeyboard-config` #page=990
	services.xserver.xkb =
	let
		options-list =
		[
			"caps:ctrl_modifier" # caps as ctrl
			        "numpad:mac" # numpad as keypad
			   "mod_led:compose" # use led to indicate modifiers
			   "altwin:menu_win" # menu as windows
		];
	in
	{
		layout = "it";
		variant = "";
		options = (
			lib.strings.concatStringsSep "," options-list
		);
	};

	services.libinput =
	{
		enable = true;

		mouse.middleEmulation = false;

		touchpad = {
			accelProfile = "adaptive";       # flat, adaptive
			clickMethod = "buttonareas"; # buttonareas, clickfinger

			# dmesg | grep i8042
			# dev = "/devices/platform/i8042/serio1/input/input5";
			middleEmulation = false;

			scrollMethod = "twofinger";
			naturalScrolling = true;

			tapping = true;
			tappingDragLock = false;
			tappingButtonMap = "lrm";
		};
	};
}

