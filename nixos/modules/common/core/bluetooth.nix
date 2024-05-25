{ config, lib, ... }:

with lib;
let cfg = config.common.core.bluetooth; in

{
	config = mkIf cfg.enable {
		hardware.bluetooth = {
			enable = true;
			settings.General.Experimental = true;
		};

		services.blueman.enable = true;
	};
}
