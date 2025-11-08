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
}

