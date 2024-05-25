{ config, lib, ... }:

with lib;
let cfg = config.system.desktop.hyprland; in

{
	imports = [
		./wayland.nix
		./hyprland.nix
	];

	options = {
		system.desktop.hyprland = {
			enable = mkOption {
				type = types.bool;
				description = "Enable hyprland software suit and support";
				default = true;
			};
		};
	};

	config = mkIf cfg.enable {
		assertions = [{
			assertion = !config.system.desktop.xfce.enable;
			message = "Cannot enable hyprland if xfce is enabled";
		}];
	};
}
