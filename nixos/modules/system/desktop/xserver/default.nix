{ config, lib, ... }:

with lib;
let cfg = config.system.desktop.xfce; in

{
	imports = [
		./x11.nix
		./xfce.nix
		./i3.nix
	];

	options = {
		system.desktop.xfce = {
			enable = mkOption {
				type = types.bool;
				description = "Enable xfce software suit and support";
				default = true;
			};
		};
	};

	config = mkIf cfg.enable {
		assertions = [{
			assertion = !config.system.desktop.hyprland.enable;
			message = "Cannot enable wayland support if xfce is enabled";
		}];
	};
}
