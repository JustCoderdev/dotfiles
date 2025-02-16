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

	options.system.desktop = {
		i3 = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable i3 software suit and support";
				default = true;
			};
		};
		thunar = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable thunar and related support";
				default = true;
			};
		};
		xfce = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable xfce software suit and support";
				default = false;
			};
		};
	};

	config =  {
		assertions = [
			{
				assertion = (cfg.xfce.enable || cfg.i3.enable) && !config.system.desktop.hyprland.enable;
				message = "Cannot enable wayland support if xfce or i3 is enabled";
			}
			{
				assertion = cfg.thunar.enable && (cfg.xfce.enable || cfg.i3.enable);
				message = "Cannot enable thunar if xfce or i3 aren't enabled";
			}
		];
	};
}
