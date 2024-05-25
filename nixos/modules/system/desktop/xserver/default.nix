{ lib, ... }:

with lib;

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
}
