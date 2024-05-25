{ lib, ... }:

with lib;

{
	imports = [
		#../xserver/x11.nix

		./hyprland.nix
		#./sway.nix # Sway OR Hyprland
		#./wayland.nix
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
