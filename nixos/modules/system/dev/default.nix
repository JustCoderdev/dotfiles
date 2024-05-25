{ lib, ... }:

with lib;

{
	imports = [
		./arduino.nix
		./c.nix
	];

	options = {
		system.dev = {
			c.enable = mkOption {
				type = types.bool;
				description = "Add c development tools and libs";
				default = true;
			};
			arduino.enable = mkOption {
				type = types.bool;
				description = "Add arduino development tools and libs";
				default = true;
			};
		};
	};
}

