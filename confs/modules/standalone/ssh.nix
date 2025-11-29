{ config, lib, ... }:

let
	cfg = config.jcconfs.module.ssh;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.ssh =
		{
			enable = true;
			addKeysToAgent = "yes";
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.ssh =
	{
		enable = lib.mkEnableOption "ssh secure shell client custom configuration";
	};
}
