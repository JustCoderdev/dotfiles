{ config, lib, ... }:

let
	cfg = config.common.core.bluetooth;
in

{
	config = lib.mkIf cfg.enable {
		hardware.bluetooth = {
			enable = true;
			settings.General.Experimental = true;
		};

		services.blueman.enable = true;
	};

	options.common.core.bluetooth = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable bluetooth support";
			default = false;
		};
	};
}
