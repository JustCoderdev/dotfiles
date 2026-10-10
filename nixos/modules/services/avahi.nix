{ config, lib, ... }:

let
	cfg = config.modules.services.avahi;
in

{
	config =
	{
		services.avahi = lib.mkIf (cfg.enable)
		{
			enable = true;
			openFirewall = true;

			nssmdns4 = true;
			nssmdns6 = false;

			ipv4 = true;
			ipv6 = true;

			# wideArea = false;

			publish = {
				enable = true;
				addresses = true;
				domain = true;
				userServices = true;
			};
		};
	};

	# ------------------------------------------------------------ #

	options.modules.services.avahi =
	{
		enable = lib.mkEnableOption "avahi service";
	};
}
