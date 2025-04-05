{ config, lib, ... }:

let
	cfg = config.system.desktop;
in

{
	imports = [
		./wayland.nix
		./hyprland.nix
		./sddm.nix
	];

	config = {
		assertions = lib.lists.optionals cfg.hyprland.enable
		[
			{
				assertion = !cfg.xfce.enable;
				message = "Cannot enable hyprland if xfce is enabled";
			}
		];
	};
}
