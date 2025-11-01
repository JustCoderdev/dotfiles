{ config, lib, pkgs, settings, ... }:

let
	dev-cfg = config.system.dev;
	cfg = dev-cfg.arduino;
in

{
	config = lib.mkIf (dev-cfg.enable && cfg.enable)
	{
		assertions = [{
			assertion = dev-cfg.c.enable;
			message = "Arduino tools requires you to enable c tools";
		}];

		environment.systemPackages = with pkgs; [ arduino ];
	};

	# ------------------------------------------------------------ #

	options.system.dev.arduino =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add arduino development tools and libs";
			default = false;
		};
	};
}
