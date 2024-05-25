{ lib, ... }:

with lib;

{
	imports = [
		./backlight
		./rebuild-system
	];

	options = {
		system.bin = {
			backlight.enable = mkOption {
				type = types.bool;
				description = "Add backlight to PATH";
				default = true;
			};
			rebuild-system.enable = mkOption {
				type = types.bool;
				description = "Add rebuild-system to PATH";
				default = true;
			};
		};
	};
}
