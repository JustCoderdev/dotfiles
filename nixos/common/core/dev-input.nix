{ pkgs, ... }:

{
	services.xserver.displayManager.setupCommands = ''
${pkgs.numlockx}/bin/numlockx on
'';

	services.xserver.xkb =
	let
		caps-as-ctrl = "caps:ctrl_modifier";
		caps-disable = "caps:none";
		numpad-default = "numpad:pc";
		numpad-as-keypad = "numpad:mac";
	in
	{
		layout = "it";
		variant = "";
		options = "${caps-as-ctrl},${numpad-as-keypad}";
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

