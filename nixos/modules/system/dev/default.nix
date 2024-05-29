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
				default = false;
			};
			arduino.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add arduino development tools and libs";
				default = false;
			};
			net.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add network development tools and apps";
				default = false;
			};
		};
	};
}

