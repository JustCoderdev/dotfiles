{ config, lib, ... }:

let cfg = config.system.desktop.hyprland; in

{
	imports = [
		./wayland.nix
		./hyprland.nix
		./sddm.nix
	];

	options = {
		system.desktop.hyprland = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable hyprland software suit and support";
				default = true;
			};
		};
	};

	config = lib.mkIf cfg.enable {
		assertions = [
		{
			assertion = !config.system.desktop.xfce.enable;
			message = "Cannot enable hyprland if xfce is enabled";
		}
		#{
		#	assertion = settings.runningVM;
		#	message = "Hyprland in VM is not supported";
		#}
		];
	};
}
