{ lib, ... }:

with lib;

{
	imports = [
		./x11.nix
		./xfce.nix
		./i3.nix
	];

	options = {
		system.desktop.xserver = {
			enable = mkOption {
				type = types.bool;
				description = "Enable x11 software suit and support";
				default = true;
			};
		};
	};
}
