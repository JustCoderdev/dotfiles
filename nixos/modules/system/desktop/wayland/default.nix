{ lib, ... }:

with lib;

{
	imports = [
		./wayland.nix
		./hyprland.nix
		#./sway.nix # Sway OR Hyprland
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
