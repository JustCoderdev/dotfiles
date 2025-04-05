{ config, lib, ... }:

let
	cfg = config.system.desktop;
in

{
	imports = [
		./i3.nix
		./thunar.nix
		./x11.nix
		./xfce.nix
	];

	config = {
		assertions = lib.lists.optionals cfg.hyprland.enable
		[
			{
				assertion = !(cfg.xfce.enable || cfg.i3.enable);
				message = "Cannot enable wayland support if xfce or i3 is enabled";
			}
		];
	};
}
