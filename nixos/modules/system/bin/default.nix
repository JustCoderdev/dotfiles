{ lib, ... }:

{
	imports = [
		./backlight
		./rebuild-system
	];

	options = {
		system.bin = {
			backlight.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add backlight to PATH";
				default = true;
			};
			rebuild-system.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Add rebuild-system to PATH";
				default = true;
			};
		};
	};
}
