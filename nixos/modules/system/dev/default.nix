{ config, lib, ... }:

let
	cfg = config.system.dev;
in

{
	imports = [
		./android.nix
		./arduino.nix
		./c.nix
		./net.nix
	];

	options = {
		system.dev = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add universal developer tools";
				default = false;
			};
			android.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add android development tools and libs";
				default = false;
			};
			arduino.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add arduino development tools and libs";
				default = false;
			};
			c.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add c development tools and libs";
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

