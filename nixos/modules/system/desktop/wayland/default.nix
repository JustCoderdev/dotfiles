{ lib, ... }:

with lib;

{
	imports = [
		../xserver/x11.nix
		./wayland.nix
		./hyprland.nix
	];

	options = {
		system.desktop.wayland = {
			enable = mkOption {
				type = types.bool;
				description = "Enable wayland software suit and support";
				default = true;
			};
		};
	};
}
