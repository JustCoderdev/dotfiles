{ lib, ... }:

{
	imports = [
		./arduino.nix
		./c.nix
	];

	options = {
		system.dev = {
			c.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add c development tools and libs";
				default = true;
			};
			arduino.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add arduino development tools and libs";
				default = true;
			};
		};
	};
}

