{ config, lib, pkgs, ... }:

{
	config = lib.mkIf (cfg.client.enable || cfg.server.enable)
	};

	# ------------------------------------------------------------ #

	options.system.hardware-manifest =
	{
	};

}
