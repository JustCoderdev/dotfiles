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
}
